Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaAZXeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 18:34:19 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040AbaAZXeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:34:18 -0500
Message-ID: <52E59B6E.6080701@nod.at>
Date: Mon, 27 Jan 2014 00:34:06 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, horms@verge.net.au,
        laurent.pinchart+renesas@ideasonboard.com
Subject: Re: [PATCH 2/2] thermal,rcar_thermal: Add dependency on HAS_IOMEM
References: <1390688954-4940-1-git-send-email-richard@nod.at> <1827069.1uKx343yy0@avalon>
In-Reply-To: <1827069.1uKx343yy0@avalon>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2014 00:30, schrieb Laurent Pinchart:
> Hi Richard,
> 
> Thank you for the patch.
> 
> On Saturday 25 January 2014 23:29:14 Richard Weinberger wrote:
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
>> +	depends on HAS_IO_MEM
> 
> Shouldn't that be HAS_IOMEM ?

m(

Of course...will resend tomorrow.

>>  	help
>>  	  Enable this to plug the R-Car thermal sensor driver into the Linux
>>  	  thermal framework.
> 

Thanks,
//richard
