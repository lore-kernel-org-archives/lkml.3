Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaLHHrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:47:20 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:56982 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLHHrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:47:18 -0500
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1417184452-11884-1-git-send-email-peter@piie.net> <1417184452-11884-4-git-send-email-peter@piie.net> <20141203090436.GC52608@vmdeb7> <cone.1417677032.220767.18692.1000@mups> <cone.1417677666.882029.18692.1000@mups>
Message-ID: <cone.1418024758.333250.18692.1000@mups>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Darren Hart <dvhart@infradead.org>
Cc: peter@piie.net, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [RESEND PATCH v5 3/5] acerhdf: Use bang-bang thermal governor
Date: Mon, 08 Dec 2014 08:45:58 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

I know you are busy and I don't want to stress you, but have you had time to 
look to this?  I'd be really happy to solve all issues in time and have 
those patches finally applied.

kind regards,
--peter;


Peter Feuerer writes:

> Hi again,
> 
> Peter Feuerer writes:
> 
>> Hi Darren,
>> 
>> thank you very much for your reply.
>> 
>> 
>> Darren Hart writes:
>> 
>>> On Fri, Nov 28, 2014 at 03:20:50PM +0100, Peter Feuerer wrote:
>>>> acerhdf has been doing an on-off fan control using hysteresis by
>>>> post-manipulating the outcome of thermal subsystem trip point handling.
>>>> This patch enables acerhdf to use the bang-bang governor, which is
>>>> intended for on-off controlled fans.
>>>> 
>>>> Cc: platform-driver-x86@vger.kernel.org
>>>> Cc: Darren Hart <dvhart@infradead.org>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> CC: Zhang Rui <rui.zhang@intel.com>
>>>> Cc: Andreas Mohr <andi@lisas.de>
>>>> Cc: Javi Merino <javi.merino@arm.com>
>>>> Acked-and-tested-by: Borislav Petkov <bp@suse.de>
>>>> Signed-off-by: Peter Feuerer <peter@piie.net>
>>>> ---
>>>>  drivers/platform/x86/Kconfig   |  3 ++-
>>>>  drivers/platform/x86/acerhdf.c | 36 +++++++++++++++++++++++++++++++-----
>>>>  2 files changed, 33 insertions(+), 6 deletions(-)
>>>> 
>>>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
>>>> index a2eabe6..c173266 100644
>>>> --- a/drivers/platform/x86/Kconfig
>>>> +++ b/drivers/platform/x86/Kconfig
>>>> @@ -38,7 +38,8 @@ config ACER_WMI
>>>>  
>>>>  config ACERHDF
>>>>  	tristate "Acer Aspire One temperature and fan driver"
>>>> -	depends on THERMAL && ACPI
>>>> +	select THERMAL_GOV_BANG_BANG
>>> 
>>> So we use select sparingly as it does implicit things.
>>> 
>>> I checked the THERMAL_GOV_BANG_BANG Kconfig entry, and the help says acerhdf
>>> already depends on it (which it doesn't appear to). Any particular reason to add
>>> select here instead of adding it as a depends.
>>> 
>>> Why did you drop THERMAL?
>> 
>> I had it like this in my first version of patches:
>> + depends on THERMAL && ACPI && THERMAL_GOV_BANG_BANG
>> 
>> But after some discussion with lkml community we ended up with the select 
>> line and dropped THERMAL dependency, as it is implied by 
>> THEMAL_GOV_BANG_BANG.  I'm not so experienced with Kconfig, so I must rely 
>> on the statements of the community in this case.
> 
> Just found the link about this discussion I had with Rui and Boris:
> http://linux-kernel.2935.n7.nabble.com/PATCH-0-4-acerhdf-thermal-adding-new-models-and-appropriate-governor-tp848572p908256.html
> 
> [...]
> 
> -- 
> kind regards,
> --peter;
