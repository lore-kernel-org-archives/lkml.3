Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaAOOMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:12:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38203 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaAOOMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:12:21 -0500
Message-ID: <52D6972B.2030704@ti.com>
Date: Wed, 15 Jan 2014 19:41:55 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/5] arm: omap3: twl: use the new lookup method with usb
 phy
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com> <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com> <52AEDE43.8030005@ti.com> <20131216144314.GB22944@xps8300> <52CBFAC0.9040103@ti.com> <20140114143849.GB21169@xps8300>
In-Reply-To: <20140114143849.GB21169@xps8300>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 14 January 2014 08:08 PM, Heikki Krogerus wrote:
> On Tue, Jan 07, 2014 at 06:31:52PM +0530, Kishon Vijay Abraham I wrote:
>>> In any case, having two device names to deal with does not add any
>>> more risk. These associations should always be made in the place where
>>> the phy device is created so you will always know it's device name.
>>
>> huh.. we should also know the 'controller' device name while defining these
>> associations and in some cases the controller device and phy device are created
>> in entirely different places.
> 
> If you don't want to use the controller device name to do the
> matching, we can use the con_id string as well. I believe the lookup
> method I use in this set just needs a small change.

The point I'm trying to make is that we won't 'always' know the device names in
advance.
Btw how are you planning to differentiate between multiple controllers of the
same type with con_id?

Maybe I'm missing the actual intention of this patch. Do you face problem if
the PHY's have to know about it's consumers in ACPI?
> 
> Is that OK with you?
> 
> 
>>> Normally the platform code creates these associations in the same
>>> place it creates the platform devices, so you definitely know what the
>>> device names will be.
>>>
>>> In this case it's actually created in drivers/mfd/twl-core.c, so I do
>>> need to update this and move the lookup table there. We can still
>>> deliver the user name as platform data, though I believe it's always
>>> "musb". Maybe we could actually skip that and just hard code the name?
>>
>> I would rather leave the way it is modelled now.
> 
> Do you mean, leave it in the platform code? Why? We would reduce the
> platform code by moving it to the mfd driver. Or did I misunderstood
> something?

In this case, the lookup table will be used only for non-dt boot so don't see
much use in moving to mfd driver.
I meant if the new method is not solving any problem then I would prefer the
way it is modelled now where the PHY's know about it's consumers.

Btw where does device gets created in ACPI boot?

Cheers
Kishon
