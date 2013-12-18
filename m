Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3LRItK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:49:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:43359 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3LRItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:49:08 -0500
Message-ID: <52B16182.9090209@linutronix.de>
Date: Wed, 18 Dec 2013 09:49:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Allen Pais <allen.pais@oracle.com>
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/3] [RESEND]sparc64: convert spinloc_t to raw_spinlock_t
 in  mmu_context_t
References: <1387345326-20185-1-git-send-email-allen.pais@oracle.com>
In-Reply-To: <1387345326-20185-1-git-send-email-allen.pais@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 06:42 AM, Allen Pais wrote:
> index 554995d..aae5aa9 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -27,6 +27,7 @@ config SPARC
>  	select HAVE_DMA_API_DEBUG
>  	select HAVE_ARCH_JUMP_LABEL
>  	select HAVE_GENERIC_HARDIRQS
> +	select IRQ_FORCED_THREADING
>  	select GENERIC_IRQ_SHOW
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select USE_GENERIC_SMP_HELPERS if SMP

Sorry for not noticing this earlier but this has nothing to do with the
remaining part of the patch.
To be able to set this flag, you need to mark timer & perf interrupts.
If you already use IRQF_TIMER for the timer and perf interrupts are
already coming as NMU then you are done. But please split this out as a
separate patch.

Sebastian
