Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161530AbaDPO2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:28:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59178 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbaDPO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:28:08 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-d7-534e937633b5
Message-id: <534E9374.6010807@samsung.com>
Date: Wed, 16 Apr 2014 16:28:04 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 5/8] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397527192-21988-6-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4Nd2yyX7BBnefc1n8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6Z6DQ5JdsFsdmLGG02LtzMqODoMeaeWsYPVqae9g8fv+axOjxd9ULZo871/aweWxe
	Uu9x5UQTq0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBl3DuwlbXgB1vFukN7mBoYb7J2MXJy
	SAiYSOzZdYYNwhaTuHBvPZDNxSEksJRR4u/vD6wQzmdGiQ0r57GDVPEKaEn0He9gArFZBFQl
	Zp5uAZvEJqAm8bnhEdgkfqCaNU3XWUBsUYEIiXuNh1khegUlfky+BxYXEXCT+PbpDzPIAmaB
	JmaJC59eM4MkhAUCJL5sPwd1RiOjxJ9FL8C2cQJ1nN90A6yIWcBaYuWkbYwQtrzE5jVvmScw
	Cs5CsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJxK87GJceszrEKMDB
	qMTDOyPHN1iINbGsuDL3EKMEB7OSCO+FNr9gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYz8bN+m
	7j1UW2S1SW//w+SKzF251ov//1UVNPVpKN1xebZk+7+IS2ubrTWzV9ec0fWrWL6Jr+uJi6pt
	gbXCgg1VtxZ92PBJqnTruafr9vNuevSrX6rt1pF3OvuXftLcVfjf5/qL4A+tmqWzlPWsjj7+
	J7mgkXu+1tOeCaxHdLaLXwpjWv/8/KVlSizFGYmGWsxFxYkAjyBFAKICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 15.04.2014 03:59, Chanwoo Choi wrote:
> This patch fix the offset of CPU boot address and don't operate smc call
> of SMC_CMD_CPU1BOOT command for Exynos3250.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos/firmware.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index aa01c42..6205d4f 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -30,13 +30,16 @@ static int exynos_do_idle(void)
>
>   static int exynos_cpu_boot(int cpu)
>   {
> +	if (soc_is_exynos3250()) {
> +		return 0;

This is strange. How the firmware knows when to boot the CPU then, if 
CPU1BOOT command is not called?

Best regards,
Tomasz
