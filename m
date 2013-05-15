Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3EOIcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:32:17 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:45976 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab3EOIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:32:14 -0400
Message-ID: <51934744.9010803@linux.vnet.ibm.com>
Date: Wed, 15 May 2013 13:58:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH] cpu remove CONFIG_INIT_ALL_POSSIBLE check
References: <1368604214-23237-1-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1368604214-23237-1-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051508-9264-0000-0000-000003C041E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 01:20 PM, liguang wrote:
> seems CONFIG_INIT_ALL_POSSIBLE is obsolete now.
> 

Um? A simple grep showed me this:

arch/s390/Kconfig:      select INIT_ALL_POSSIBLE
arch/m32r/Kconfig:      select INIT_ALL_POSSIBLE
arch/parisc/Kconfig:    select INIT_ALL_POSSIBLE
init/Kconfig:config INIT_ALL_POSSIBLE

Regards,
Srivatsa S. Bhat

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/cpu.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index cd166d3..2697d1a 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -662,12 +662,7 @@ EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
>  const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
>  EXPORT_SYMBOL(cpu_all_bits);
> 
> -#ifdef CONFIG_INIT_ALL_POSSIBLE
> -static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
> -	= CPU_BITS_ALL;
> -#else
>  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
> -#endif
>  const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
>  EXPORT_SYMBOL(cpu_possible_mask);
> 

