Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaALMRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:17:00 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47275 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaALMQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:16:56 -0500
Message-ID: <52D287B1.3090106@gmail.com>
Date: Sun, 12 Jan 2014 13:16:49 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH RFC 01/10] ARM: s3c64xx: pm: Use name field of generic_pm_domain
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com> <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com> <20140112114717.GA31318@amd.pavel.ucw.cz>
In-Reply-To: <20140112114717.GA31318@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 12.01.2014 12:47, Pavel Machek wrote:
> On Sat 2014-01-11 20:42:43, Tomasz Figa wrote:
>> This patch removes name field from private s3c64xx_pm_domain struct and
>> moves domain name to dedicated field of generic_pm_domain struct.
>>
>> When at it, beautify the names a bit, since they are used by genpd core
>> as message prefixes.
>>
>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>> ---
>>   arch/arm/mach-s3c64xx/pm.c | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/mach-s3c64xx/pm.c b/arch/arm/mach-s3c64xx/pm.c
>> index 8cdb824..5238d66 100644
>> --- a/arch/arm/mach-s3c64xx/pm.c
>> +++ b/arch/arm/mach-s3c64xx/pm.c
>> @@ -35,7 +35,6 @@
>>   #include "regs-syscon-power.h"
>>
>>   struct s3c64xx_pm_domain {
>> -	char *const name;
>>   	u32 ena;
>>   	u32 pwr_stat;
>>   	struct generic_pm_domain pd;
>> @@ -76,7 +75,7 @@ static int s3c64xx_pd_on(struct generic_pm_domain *domain)
>>   		} while (retry--);
>>
>>   		if (!retry) {
>> -			pr_err("Failed to start domain %s\n", pd->name);
>> +			pr_err("Failed to start domain %s\n", pd->pd.name);
>>   			return -EBUSY;
>>   		}
>
>
> So you changed text "failed to start domain I" to "failed to start
> domain domain_i". Not sure that's an improvement...?

Right. I apparently missed this, since this error should never happen 
unless there is something wrong with your hardware (SoC or PMIC).

Still, the generic code in drivers/base/power/domain.c does not add the 
"domain" prefix to the message. Without this patch it was printing 
messages like

I: Power-on latency exceeded, new value 1000 ns

I'd say that what's need adjustment are the messages in 
mach-s3c64xx/pm.c to print "%s: Failed to start\n" and keep things 
consistent with higher level code.

>
> Could we get some more descriptive names for the domains?

They are listed like this in user's manual, e.g. DOMAIN_F, DOMAIN_I, 
DOMAIN_G, etc.

Best regards,
Tomasz
