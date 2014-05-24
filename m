Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaEXRoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:44:34 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43021 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaEXRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:44:31 -0400
Message-ID: <5380DA78.5040900@gmail.com>
Date: Sat, 24 May 2014 19:44:24 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v10 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com> <1400841343-6016-2-git-send-email-t.dakhran@samsung.com> <537FB995.5070604@gmail.com> <53806759.40908@samsung.com>
In-Reply-To: <53806759.40908@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

On 24.05.2014 11:33, Tarek Dakhran wrote:
> Hi Tomasz
> 
> I faced another problem, while changing this patch.
> See below.
> 
> On 05/24/2014 01:11 AM, Tomasz Figa wrote:
>> Hi Tarek,
>>
>> With v2 of the series I mentioned in review of previous version [1],
>> this patch can be skipped.
>>
>> [1] http://www.spinics.net/lists/linux-samsung-soc/msg31258.html
>>
>> Best regards,
>> Tomasz
>>
>> On 23.05.2014 12:35, Tarek Dakhran wrote:
>>> EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
>>> Add initial support for this SoC.
>>>
>>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>>> ---
>>>   arch/arm/mach-exynos/Kconfig    |    8 ++++++++
>>>   arch/arm/mach-exynos/common.h   |   11 ++++++++++-
>>>   arch/arm/mach-exynos/firmware.c |    2 +-
>>>   3 files changed, 19 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
>>> index 1602abc..79a3e85 100644
>>> --- a/arch/arm/mach-exynos/Kconfig
>>> +++ b/arch/arm/mach-exynos/Kconfig
>>> @@ -84,6 +84,14 @@ config SOC_EXYNOS5250
>>>       help
>>>         Enable EXYNOS5250 SoC support
>>>   +config SOC_EXYNOS5410
>>> +    bool "SAMSUNG EXYNOS5410"
>>> +    default y
>>> +    depends on ARCH_EXYNOS5
>>> +    select PM_GENERIC_DOMAINS if PM_RUNTIME
>>> +    help
>>> +      Enable EXYNOS5410 SoC support
>>> +
>>>   config SOC_EXYNOS5420
>>>       bool "SAMSUNG EXYNOS5420"
>>>       default y
>>> diff --git a/arch/arm/mach-exynos/common.h
>>> b/arch/arm/mach-exynos/common.h
>>> index e2d0954..d64c6de 100644
>>> --- a/arch/arm/mach-exynos/common.h
>>> +++ b/arch/arm/mach-exynos/common.h
>>> @@ -21,6 +21,7 @@
>>>   #define EXYNOS4_CPU_MASK    0xFFFE0000
>>>     #define EXYNOS5250_SOC_ID    0x43520000
>>> +#define EXYNOS5410_SOC_ID    0xE5410000
>>>   #define EXYNOS5420_SOC_ID    0xE5420000
>>>   #define EXYNOS5440_SOC_ID    0xE5440000
>>>   #define EXYNOS5_SOC_MASK    0xFFFFF000
>>> @@ -37,6 +38,7 @@ IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID,
>>> EXYNOS4_CPU_MASK)
>>>   IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
>>>   IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
>>>   IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
>>> +IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
>>>   IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
>>>   IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
>>>   @@ -68,6 +70,12 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID,
>>> EXYNOS5_SOC_MASK)
>>>   # define soc_is_exynos5250()    0
>>>   #endif
>>>   +#if defined(CONFIG_SOC_EXYNOS5410)
>>> +# define soc_is_exynos5410()    is_samsung_exynos5410()
>>> +#else
>>> +# define soc_is_exynos5410()    0
>>> +#endif
>>> +
>>>   #if defined(CONFIG_SOC_EXYNOS5420)
>>>   # define soc_is_exynos5420()    is_samsung_exynos5420()
>>>   #else
>>> @@ -82,7 +90,8 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID,
>>> EXYNOS5_SOC_MASK)
>>>     #define soc_is_exynos4() (soc_is_exynos4210() ||
>>> soc_is_exynos4212() || \
>>>                 soc_is_exynos4412())
>>> -#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420())
>>> +#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410()
>>> || \
>>> +              soc_is_exynos5420())
>>>   
> This is the place where we need it.
> Or this macro should be changed (maybe read compatible property from dt).
> 

The problem is in fact not here, but in code using this macro. Let's
see, what git grep[1] gives us:

> arch/arm/mach-exynos/exynos.c-static void __init exynos_map_io(void)
> arch/arm/mach-exynos/exynos.c-{
> arch/arm/mach-exynos/exynos.c-  if (soc_is_exynos4())
> arch/arm/mach-exynos/exynos.c-          iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
> arch/arm/mach-exynos/exynos.c-
> arch/arm/mach-exynos/exynos.c:  if (soc_is_exynos5())
> arch/arm/mach-exynos/exynos.c-          iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));

OK, so we have an array of static mappings, which can't be handled using
DT yet. That would probably explain why it fails to boot.

> arch/arm/mach-exynos/exynos.c-}

> arch/arm/mach-exynos/exynos.c-static void __init exynos_dt_machine_init(void)
> arch/arm/mach-exynos/exynos.c-{
[snip]
> arch/arm/mach-exynos/exynos.c:  if (soc_is_exynos5()) {
> arch/arm/mach-exynos/exynos.c-          for_each_compatible_node(i2c_np, NULL, i2c_compat) {
> arch/arm/mach-exynos/exynos.c-                  if (of_device_is_available(i2c_np)) {
> arch/arm/mach-exynos/exynos.c-                          id = of_alias_get_id(i2c_np, "i2c");
> arch/arm/mach-exynos/exynos.c-                          if (id < 4) {
> arch/arm/mach-exynos/exynos.c-                                  tmp = readl(EXYNOS5_SYS_I2C_CFG);
> arch/arm/mach-exynos/exynos.c-                                  writel(tmp & ~(0x1 << id),
> arch/arm/mach-exynos/exynos.c-                                                  EXYNOS5_SYS_I2C_CFG);
> arch/arm/mach-exynos/exynos.c-                          }
> arch/arm/mach-exynos/exynos.c-                  }
> arch/arm/mach-exynos/exynos.c-          }

This one handles I2C interrupt signal mux and I'm not quite sure if
soc_is_exynos5() is the right condition here, but at least it shouldn't
cause crashes.

OK, so this means that soc_is_exynos5410() must stay until the remaining
low level drivers that currently use static mappings are rewritten
properly. So the only bit to be dropped from this patch is the change to
firmware.c, which is not needed any longer.

[1] The command used (on linux-next/master):
git grep -20 soc_is_exynos5\( arch/arm/mach-exynos/

Best regards,
Tomasz
