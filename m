Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3FROz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:55:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42350 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab3FROz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:55:57 -0400
Message-ID: <51C074C4.5000601@ti.com>
Date: Tue, 18 Jun 2013 20:25:00 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 5/9] ARM: OMAP: USB: Add phy binding information
References: <1371113039-5784-1-git-send-email-kishon@ti.com> <1371113039-5784-6-git-send-email-kishon@ti.com> <20130618094438.GT5461@arwen.pp.htv.fi> <51C030B4.5070707@ti.com> <20130618102725.GB7843@arwen.pp.htv.fi> <51C040E8.2050904@ti.com> <20130618123536.GD8620@arwen.pp.htv.fi>
In-Reply-To: <20130618123536.GD8620@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18 June 2013 06:05 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jun 18, 2013 at 04:43:44PM +0530, Kishon Vijay Abraham I wrote:
>>> On Tue, Jun 18, 2013 at 03:34:36PM +0530, Kishon Vijay Abraham I wrote:
>>>> On Tuesday 18 June 2013 03:14 PM, Felipe Balbi wrote:
>>>>> On Thu, Jun 13, 2013 at 02:13:55PM +0530, Kishon Vijay Abraham I wrote:
>>>>>> In order for controllers to get PHY in case of non dt boot, the phy
>>>>>> binding information (phy device name) should be added in the platform
>>>>>> data of the controller.
>>>>>>
>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>
>>>>> I would rather not pass strings around, any other way to handle this ?
>>>>> Why do you need to pass this string ?
>>>>
>>>> Our old way of binding the controller and the phy using device name
>>>> started creating problems after the devices are created using
>>>> PLATFORM_DEVID_AUTO. Infact non-dt boot is broken in mainline for
>>>> OMAP3 platforms for which I have posted a RFC series
>>>> http://www.serverphorums.com/read.php?12,708632 which also uses
>>>> strings.
>>>> I'm not sure of any other way to deal with this.
>>>
>>> have you checked how other frameworks handle it ? Regulator has some
>>> sort of binding in board-files, but I guess it passes the regulator
>>> name?
>>
>>  From whatever I could make of, regulator has 3 ways to get the
>> regulator one of which is using the binding in board-files (but it
>> also uses device name which could create the same problem that we are
>> facing).
>>
>> 1.) from dt data
>> 2.) from _supply_ name
>> 3.) from binding in board file
>>
>> (referred regulator_dev_lookup() in regulator/core.c)
>
> right, spot on. Which means we don't have a better, more elegant
> solution now. Let's go ahead with this.

Ok. So I'll drop RFC and resend this patch series
http://www.serverphorums.com/read.php?12,708632

Thanks
Kishon
