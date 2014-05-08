Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaEHErM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 00:47:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37517 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaEHErJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 00:47:09 -0400
Date: Thu, 8 May 2014 10:17:53 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-ia64@vger.kernel.org,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        Ingo Molnar <mingo@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        akataria@vmware.com, Tony Luck <tony.luck@intel.com>,
        Kevin Hao <haokexin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFT PATCH -next ] [BUGFIX] kprobes: Fix "Failed to find
 blacklist" error on ia64 and ppc64
Message-ID: <20140508044753.GA13413@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <536A16A6.5040709@hitachi.com>
 <20140507115551.22259.70581.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507115551.22259.70581.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050804-5806-0000-0000-000024D29633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 08:55:51PM +0900, Masami Hiramatsu wrote:

...

> +#if defined(CONFIG_PPC64) && (!defined(_CALL_ELF) || _CALL_ELF == 1)
> +/*
> + * On PPC64 ABIv1 the function pointer actually points to the
> + * function's descriptor. The first entry in the descriptor is the
> + * address of the function text.
> + */
> +#define constant_function_entry(fn)	(((func_descr_t *)(fn))->entry)
> +#else
> +#define constant_function_entry(fn)	((unsigned long)(fn))
> +#endif
> +
>  #endif /* __ASSEMBLY__ */

Hi Masami,

You could just use ppc_function_entry() instead.

Ananth

