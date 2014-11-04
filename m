Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaKDRwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:52:45 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:53821 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaKDRwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:52:42 -0500
Message-ID: <54591265.3030207@compulab.co.il>
Date: Tue, 04 Nov 2014 19:52:37 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
References: <20141102180756.GH31454@atomide.com> <5458D29E.50908@compulab.co.il> <20141104154231.GP31454@atomide.com>
In-Reply-To: <20141104154231.GP31454@atomide.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/14 17:42, Tony Lindgren wrote:
> * Igor Grinberg <grinberg@compulab.co.il> [141104 05:22]:
>> Hi Tony,
>>
>> On 11/02/14 20:07, Tony Lindgren wrote:
>>> Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
>>> configuration") enabled configuring the PM features for twl4030.
>>>
>>> This caused poweroff command to fail on devices that have the
>>> BCI charger on twl4030 wired, or have power wired for VBUS.
>>> Instead of powering off, the device reboots. This is because
>>> voltage is detected on charger or VBUS with the default bits
>>> enabled for the power transition registers.
>>>
>>> To fix the issue, let's just clear VBUS and CHG bits as we want
>>> poweroff command to keep the system powered off.
>>
>> What about devices that really need to start once VBUS or CHG is connected?
> 
> More handling can be added for some cases. With this patch the
> poweron bits will clear to defaults if power is completely removed.
> So start-up with VBUS and CHG works in that case.
> 
> However, if you have a battery connected, and you poweroff, with
> this patch the device won't power up with VBUS or CHG connected.
> 
> Note that most battery operated devices are not using the charger
> on twl4030 because it has issues charging a completely empty
> battery AFAIK. So most battery powered devices have been using an
> external USB charger chip that's not affected by this patch.
> 
> We could consider exporting a function for the charger driver to
> configure the poweron mask. And we could also consider passing a
> mask in ti,use_poweroff = 0xff.

Ok. That sounds better to me.
Yet, if you say there are no such devices in practice,
IMHO, we can merge this.

> 
>> It seems to me that forcing these bits on power off can break that kind of
>> devices and these settings should really be board specific.
>> What do you think?
> 
> There's a patch series for "[RFC,01/16] kernel: Add support for
> poweroff handler call chain" that should help with that. For sure
> the poweroff handling needs to be board specific as some systems
> may need to use a GPIO to shut off a regulator powering something
> before powering off the SoC.

Yes, I've seen this series.
I'm not sure though that I understand how is this supposed
to be used with DT...
Through the regulator bindings?
Which will tell it to hook up on the call chain?


-- 
Regards,
Igor.
