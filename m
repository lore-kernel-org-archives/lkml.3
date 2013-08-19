Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab3HSG6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:58:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47306 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3HSG6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:58:22 -0400
Date: Mon, 19 Aug 2013 08:58:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20130819065817.GB23742@gmail.com>
References: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819142633.82fb06bfa3bc0276fb09cbea@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> arch/x86/kernel/paravirt.c:66:0: warning: "DEF_NATIVE" redefined [enabled by default]
>  #define DEF_NATIVE(ops, name, code)     \
>  ^
> In file included from arch/x86/include/asm/ptrace.h:65:0,
>                  from arch/x86/include/asm/alternative.h:8,
>                  from arch/x86/include/asm/bitops.h:16,
>                  from include/linux/bitops.h:22,
>                  from include/linux/kernel.h:10,
>                  from include/linux/cache.h:4,
>                  from include/linux/time.h:4,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from arch/x86/kernel/paravirt.c:22:
> arch/x86/include/asm/paravirt_types.h:391:0: note: this is the location of the previous definition
>  #define DEF_NATIVE(ops, name, code)      \
>  ^
> 
> Introduced by commit 9a55fdbe941e ("x86, asmlinkage, paravirt: Add
> __visible/asmlinkage to xen paravirt ops").  The 2 definitions used to be
> identical ... maybe there should be only one.

Andi, please send a fix for this build warning, against 
tip:x86/asmlinkage.

Thanks,

	Ingo

