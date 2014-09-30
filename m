Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaI3UDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:03:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:33197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaI3UDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:03:30 -0400
Date: Tue, 30 Sep 2014 22:03:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: Quark: Comment setup_arch for TLB/PGE bugfix
In-Reply-To: <1412046710-2686-4-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1409302140140.4455@nanos>
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie> <1412046710-2686-4-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Bryan O'Donoghue wrote:
>  
> +	/*
> +	 * Locate the page directory and flush the TLB.

s/Locate/Load/ ?

Thats what we do here. CR3 is used by the CPU to locate the page
directory.

> +	 *
> +	 * On Quark X1000 CPUs we still have the PGE bit incorrectly set
> +	 * due to a processor erratum, so __flush_tlb_all() is not yet
> +	 * doing what it says.  Fortunately we have a cr3 load here,
> +	 * which is what is needed on this processor to flush TLBs, so
> +	 * there's no need to add a Quark X1000 quirk here.
> +	 *
> +	 * early_init_intel will unset the X86_FEATURE_PGE flag later
> +	 * and __flush_tlb_all() will flush via cr3

Can we please write that a bit less convoluted?

> +	 */
>  	load_cr3(swapper_pg_dir);

	/*
	 * Note: Quark X1000 CPUs advertise PGE incorrectly and require
	 * a cr3 based tlb flush, so the following __flush_tlb_all()
	 * will not flush anything because the cpu quirk which clears
	 * X86_FEATURE_PGE has not been invoked yet. Though due to the
	 * load_cr3() above the TLB has been flushed already. The
	 * quirk is invoked before subsequent calls to __flush_tlb_all()
	 * so proper operation is guaranteed.
	 */
>  	__flush_tlb_all();

Thanks,

	tglx
