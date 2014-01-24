Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaAXKzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:55:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42360 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbaAXKzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:55:23 -0500
Date: Fri, 24 Jan 2014 10:54:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5 4/8] ARM: do CPU-specific init for Broadcom Brahma15
 cores
Message-ID: <20140124105448.GA814@e106331-lin.cambridge.arm.com>
References: <1390361452-3124-1-git-send-email-marc.ceeeee@gmail.com>
 <1390361452-3124-5-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390361452-3124-5-git-send-email-marc.ceeeee@gmail.com>
Thread-Topic: [PATCH v5 4/8] ARM: do CPU-specific init for Broadcom
 Brahma15 cores
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 03:30:48AM +0000, Marc Carino wrote:
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

On the third posting, Will Deacon asked if the hwcap override was really
required [1]. Two postings later there's been no answer.

Is your CPUID_EXT_ISAR0 value wrong? If so, please add a comment to that
effect (as with __krait_proc_info).

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/225895.html
