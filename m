Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaBZL7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:59:50 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242AbaBZL7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:59:48 -0500
Message-ID: <530DD72A.6@nod.at>
Date: Wed, 26 Feb 2014 12:59:38 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH v2] thermal,rcar_thermal: Add dependency on HAS_IOMEM
References: <1390812058-9002-1-git-send-email-richard@nod.at> <2789122.Lrp2LJzQED@avalon>
In-Reply-To: <2789122.Lrp2LJzQED@avalon>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2014 12:32, schrieb Laurent Pinchart:
> Hi Richard,
> 
> Thank you for the patch.
> 
> On Monday 27 January 2014 09:40:58 Richard Weinberger wrote:
>> Commit beeb5a1e (thermal: rcar-thermal: Enable driver compilation with
>> COMPILE_TEST) broke build on archs wihout io memory.
>>
>> On archs like S390 or um this driver cannot build nor work.
>> Make it depend on HAS_IOMEM to bypass build failures.
>>
>> drivers/thermal/rcar_thermal.c:404: undefined reference to
>> `devm_ioremap_resource' drivers/thermal/rcar_thermal.c:426: undefined
>> reference to `devm_ioremap_resource'
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I'm not the driver maintainer so I won't take this patch in my tree. Could you 
> please keep an eye on it to make sure it gets picked by the maintainers ?

Ping?

Thanks,
//richard

>> ---
>>  drivers/thermal/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 35c0664..88efa8f 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -136,6 +136,7 @@ config SPEAR_THERMAL
>>  config RCAR_THERMAL
>>  	tristate "Renesas R-Car thermal driver"
>>  	depends on ARCH_SHMOBILE || COMPILE_TEST
>> +	depends on HAS_IOMEM
>>  	help
>>  	  Enable this to plug the R-Car thermal sensor driver into the Linux
>>  	  thermal framework.
> 
