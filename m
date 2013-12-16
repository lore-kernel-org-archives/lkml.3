Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3LPK0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:26:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:58970 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3LPK0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:26:53 -0500
Message-ID: <52AED56B.2090102@linutronix.de>
Date: Mon, 16 Dec 2013 11:26:51 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Allen Pais <allen.pais@oracle.com>
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 1/3] sparc64: use generic rwsem spinlocks rt
References: <1387166853-10782-1-git-send-email-allen.pais@oracle.com> <1387166853-10782-2-git-send-email-allen.pais@oracle.com>
In-Reply-To: <1387166853-10782-2-git-send-email-allen.pais@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 05:07 AM, Allen Pais wrote:
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -179,12 +179,10 @@ config NR_CPUS
>  source kernel/Kconfig.hz
>  
>  config RWSEM_GENERIC_SPINLOCK
> -	bool
> -	default y if SPARC32
> +	def_bool PREEMPT_RT_FULL
>  
>  config RWSEM_XCHGADD_ALGORITHM
> -	bool
> -	default y if SPARC64
> +	def_bool !RWSEM_GENERIC_SPINLOCK && !PREEMPT_RT_FULL
>  
>  config GENERIC_HWEIGHT
>  	bool


davem won't apply this because the PREEMPT_RT symbol is not available
upstream. I referred to patch two+.

Sebastian
