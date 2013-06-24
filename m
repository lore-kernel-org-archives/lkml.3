Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3FXT5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:57:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:51557 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3FXT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:57:05 -0400
Date: Mon, 24 Jun 2013 21:57:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 23/32] x86: delete __cpuinit usage from all x86 files
In-Reply-To: <1372102237-8757-24-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.DEB.2.02.1306242156450.4013@ionos.tec.linutronix.de>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com> <1372102237-8757-24-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> Note that some harmless section mismatch warnings may result, since
> notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
> are flagged as __cpuinit  -- so if we remove the __cpuinit from
> arch specific callers, we will also get section mismatch warnings.
> As an intermediate step, we intend to turn the linux/init.h cpuinit
> content into no-ops as early as possible, since that will get rid
> of these warnings.  In any case, they are temporary and harmless.
> 
> This removes all the arch/x86 uses of the __cpuinit macros from
> all C files.  x86 only had the one __CPUINIT used in assembly files,
> and it wasn't paired off with a .previous or a __FINIT, so we can
> delete it directly w/o any corresponding additional change there.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
