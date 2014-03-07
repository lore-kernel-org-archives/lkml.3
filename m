Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaCGWUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:20:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41539 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaCGWUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:20:40 -0500
Date: Fri, 7 Mar 2014 23:20:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140307222018.GG5255@pd.tnic>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
 <20140307191050.GA10961@redhat.com>
 <531A33A2.5030706@linux.intel.com>
 <20140307213856.GF5255@pd.tnic>
 <20140307220655.GA580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140307220655.GA580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 05:06:55PM -0500, Dave Jones wrote:
> Additionally, fam:6 model:6 stepping 3 never existed in the real
> world afaict. I used to keep x86info's stepping db pretty up to date,
> and that only has knowledge of stepping 1 & 2.[*] Modelling qemu on
> something from the real world might be a better idea than inventing
> new special cases.

Yep.

I'm afraid this qemu64 is some migration/machine snapshot model which
they're using by defining a minimal set of feature bits so that
cross-vendor migration can work. WTH do I know - virt. people are crazy
anyway - that's a given. :-P

>  > Oh, and the thing has CPUID_EXT2_LM which is also a WTH moment for me.
>  > Paolo, what's going on here?
> 
> Yeah, this is a mess, there should be no family < 0xf with LM set.

Right.

> [*] It's possible I somehow missed it, or the AMD rev docs never mentioned it
> for some reason, but it seems unlikely.

Yeah, I think the test in the kernel is open above as a precaution in
case newer models appeared:

        if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||

I hardly can imagine, though, if anyone is actually booting recent
kernels on a K7. We might just as well kill this code and not even miss
it.

Btw, and sometimes when digging around, one can get lucky:
http://support.amd.com/TechDocs/23542a.pdf

K6. Ancient history stuff - I feel like I'm in a museum :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
