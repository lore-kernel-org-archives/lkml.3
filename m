Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaAORUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:20:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbaAORUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:20:30 -0500
Date: Wed, 15 Jan 2014 17:19:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/7] ARM: do CPU-specific init for Broadcom Brahma15
 cores
Message-ID: <20140115171953.GB28782@mudshark.cambridge.arm.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <1389743333-16741-4-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389743333-16741-4-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:48:49PM +0000, Marc Carino wrote:
> Perform any CPU-specific initialization required on the
> Broadcom Brahma-15 core.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/mm/proc-v7.S |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index bd17819..98ea423 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -193,6 +193,7 @@ __v7_cr7mp_setup:
>  	b	1f
>  __v7_ca7mp_setup:
>  __v7_ca15mp_setup:
> +__v7_b15mp_setup:
>  	mov	r10, #0
>  1:
>  #ifdef CONFIG_SMP
> @@ -494,6 +495,16 @@ __v7_ca15mp_proc_info:
>  	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
>  
>  	/*
> +	 * Broadcom Corporation Brahma-B15 processor.
> +	 */
> +	.type	__v7_b15mp_proc_info, #object
> +__v7_b15mp_proc_info:
> +	.long	0x420f00f0
> +	.long	0xff0ffff0
> +	__v7_proc __v7_b15mp_setup, hwcaps = HWCAP_IDIV

You only need to specify HWCAP_IDIV if you screwed up your idregs (namely
CPUID_EXT_ISAR0). Do you actually need this for your core?

Will
