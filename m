Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaAIMYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:24:08 -0500
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:49340 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086AbaAIMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:24:03 -0500
Message-ID: <52CE94DE.40604@overkiz.com>
Date: Thu, 09 Jan 2014 13:23:58 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: smc: bug fix in sam9_smc_cs_read()
References: <1389268187-23585-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1389268187-23585-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10737144462425684057
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 12:49, Jean-Jacques Hiblot wrote:
> There was a copy/paste error when reading the nwe_pulse value.
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   arch/arm/mach-at91/sam9_smc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
> index 99a0a1d..b26156b 100644
> --- a/arch/arm/mach-at91/sam9_smc.c
> +++ b/arch/arm/mach-at91/sam9_smc.c
> @@ -101,7 +101,7 @@ static void sam9_smc_cs_read(void __iomem *base,
>   	/* Pulse register */
>   	val = __raw_readl(base + AT91_SMC_PULSE);
>   
> -	config->nwe_setup = val & AT91_SMC_NWEPULSE;
> +	config->nwe_pulse = val & AT91_SMC_NWEPULSE;
>   	config->ncs_write_pulse = (val & AT91_SMC_NCS_WRPULSE) >> 8;
>   	config->nrd_pulse = (val & AT91_SMC_NRDPULSE) >> 16;
>   	config->ncs_read_pulse = (val & AT91_SMC_NCS_RDPULSE) >> 24;

