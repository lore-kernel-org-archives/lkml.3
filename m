Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3DWRwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:52:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab3DWRwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:52:08 -0400
Message-ID: <5176C9FC.4080306@ti.com>
Date: Tue, 23 Apr 2013 20:50:52 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 0/2] OMAP: fix boot sequence
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com> <20130423173442.GF10155@atomide.com>
In-Reply-To: <20130423173442.GF10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.172]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:34 PM, Tony Lindgren wrote:
> * Grygorii Strashko <grygorii.strashko@ti.com> [130423 06:25]:
>> Hi
>>
>> There are two public discussions now related to OMAP boot and drivers
>> initialization issues:
>> "Multiple issues with omap4 panda es in linux next"
>>    http://www.spinics.net/lists/linux-omap/msg90241.html
>> "[BUG] omap: mfd/regulator: twl/core: init order"
>>    http://www.spinics.net/lists/linux-omap/msg89980.html
>>
>> In both cases there are pinctrl-single/I2C/MFD/Regulators initailization issue:
>> - regulators are not initialized because of twl,
>> - twl is not initialized because of I2C,
>> - I2C is not initialized because of pinctrl-single,
>> - pinctrl-single is initialized at mudule/device init time.
>> So, most everything will be shifted at late_initcall time.
>>
>> This may cause boot delay (more over, it can broken initialization of drivers
>> which are not ready to use deferred probe mechanism yet, for example DSS).
>>
>> Introduced pathes shift I2C and TWL iniialization to module/device init layer
>> instead of subsys init layer where initialization dependencies resolved
>> indirectly in drivers/Makefile now.
>>
>> Grygorii Strashko (2):
>>    i2c: omap: convert to module_platform_driver()
>>    mfd: twl-core: convert to module_i2c_driver()
>>
>>   drivers/i2c/busses/i2c-omap.c |   14 +-------------
>>   drivers/mfd/twl-core.c        |   12 +-----------
>>   2 files changed, 2 insertions(+), 24 deletions(-)
> Thanks, I have few questions:
>
> 1. It seems that the real fix to the issues we're seeing
>     is to make the broken drivers to support -EPROBE_DEFER?
yes.
>
> 2. If so, can these be merged later on as clean-up?
if i understand Tomi correctly, he has problems with DSS updating to use
  -EPROBE_DEFER, so this is rather fix than clean-up.
But need confirmation that it's true from him.
>
> 3. Can these two patches be merged separately without
>     breaking things?
I think, yes.
>
> Regards,
>
> Tony

