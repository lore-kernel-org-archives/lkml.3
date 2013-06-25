Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3FYVma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:42:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44079 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3FYVm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:42:28 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Robin Holt <holt@sgi.com>, Linus Walleij <linus.walleij@linaro.org>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Russ Anderson <rja@sgi.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>
Subject: Re: linux-next: panda build failed at arch/arm/mach-omap2/omap4-restart.c
References: <CA+G9fYv_9EQUmpRNPUwioSwJVXnXJC5odEKiMd=vKHNWYRT8xw@mail.gmail.com>
	<CA+G9fYupw8Gi=5p2nKVJ9GqfhwBcTw7hyzGA8+K+gHmdL96mJg@mail.gmail.com>
Date: Tue, 25 Jun 2013 14:42:24 -0700
In-Reply-To: <CA+G9fYupw8Gi=5p2nKVJ9GqfhwBcTw7hyzGA8+K+gHmdL96mJg@mail.gmail.com>
	(Naresh Kamboju's message of "Tue, 25 Jun 2013 22:46:02 +0530")
Message-ID: <874ncluatb.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> ping

This is a known issue[1] and already has some proposed fixes, they are just
not merged yet.

Kevin

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/178209.html

> On 23 June 2013 13:53, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>> Hi,
>>
>> panda build broken on linux-next branch
>>
>> kernel_config=omap2plus_defconfig
>> KERNEL_VERSION=3.10.0-rc6
>> KERNEL_GIT=git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>> KERNEL_COMMIT=e1a86578747376f08985627c84df088a5d0d1e92
>>
>> Build error log :
>> -------------------
>> 04:43:18   CC      arch/arm/mach-omap2/omap4-restart.o
>> 04:43:18 /mnt/ci_build/workspace/linux-next/hwpack/panda/label/kernel_cloud/arch/arm/mach-omap2/omap4-restart.c:21:28:
>> warning: ‘enum reboot_mode’ declared inside parameter list [enabled by
>> default]
>> 04:43:18  void omap44xx_restart(enum reboot_mode mode, const char *cmd)
>> 04:43:18                             ^
>> 04:43:18 /mnt/ci_build/workspace/linux-next/hwpack/panda/label/kernel_cloud/arch/arm/mach-omap2/omap4-restart.c:21:28:
>> warning: its scope is only this definition or declaration, which is
>> probably not what you want [enabled by default]
>> 04:43:18 /mnt/ci_build/workspace/linux-next/hwpack/panda/label/kernel_cloud/arch/arm/mach-omap2/omap4-restart.c:21:40:
>> error: parameter 1 (‘mode’) has incomplete type
>> 04:43:18  void omap44xx_restart(enum reboot_mode mode, const char *cmd)
>> 04:43:18                                         ^
>> 04:43:18 /mnt/ci_build/workspace/linux-next/hwpack/panda/label/kernel_cloud/arch/arm/mach-omap2/omap4-restart.c:21:6:
>> warning: function declaration isn’t a prototype [-Wstrict-prototypes]
>> 04:43:18  void omap44xx_restart(enum reboot_mode mode, const char *cmd)
>> 04:43:18       ^
>> 04:43:18 make[2]: *** [arch/arm/mach-omap2/omap4-restart.o] Error 1
>> 04:43:18 make[1]: *** [arch/arm/mach-omap2] Error 2
>>
>> Full build log:
>> ------------------
>> https://ci.linaro.org/jenkins/job/linux-next/hwpack=panda,label=kernel_cloud/lastBuild/console
>>
>> Suspecting patch which caused build failed:
>> --------------------------------------------------------
>> commit b61cdf2aebc5cd2f4efc4e0cbebeb8a91884a43e
>> Author: Robin Holt <holt@sgi.com>
>> Date:   Wed Jun 19 10:08:43 2013 +1000
>>
>> reboot: arm: change reboot_mode to use enum reboot_mode
>>
>> Preparing to move the parsing of reboot= to generic kernel code forces the
>> change in reboot_mode handling to use the enum.
>>
>> Signed-off-by: Robin Holt <holt@sgi.com>
>>
>> ...
>> diff --git a/arch/arm/mach-omap2/omap4-restart.c
>> b/arch/arm/mach-omap2/omap4-restart.c
>> index f90e02e..652adde 100644
>> --- a/arch/arm/mach-omap2/omap4-restart.c
>> +++ b/arch/arm/mach-omap2/omap4-restart.c
>> @@ -18,7 +18,7 @@
>>   * Resets the SoC.  For @cmd, see the 'reboot' syscall in
>>   * kernel/sys.c.  No return value.
>>   */
>> -void omap44xx_restart(char mode, const char *cmd)
>> +void omap44xx_restart(enum reboot_mode mode, const char *cmd)
>>  {
>>         /* XXX Should save 'cmd' into scratchpad for use after reboot */
>>         omap4_prminst_global_warm_sw_reset(); /* never returns */
>> ...
>>
>> Best regards
>> Naresh Kamboju
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
