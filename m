Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIYPLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:11:31 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59733 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaIYPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:11:28 -0400
Date: Thu, 25 Sep 2014 17:11:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
Message-ID: <20140925151123.GA4864@gmail.com>
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie>
 <20140925045755.GA20431@gmail.com>
 <5423E1F7.5010000@nexus-software.ie>
 <20140925145126.GA4434@gmail.com>
 <54242F17.5010503@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54242F17.5010503@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:

> >It talks about:
> >
> >+       /*
> >+        * Locate the page directory and flush the TLB.
> >+        * On Quark X1000 rewriting CR3 flushes the TLB no if/else is required
> >+        * to choose between __flush_tlb() and __flush_tlb_all()
> >+        */
> >         load_cr3(swapper_pg_dir);
> >         __flush_tlb_all();
> >
> >But it is completely silent on the real reason for why we don't
> >need a Quark quirk here, which would be something like:
> >
> >	/*
> >	 * On Quark CPUs we still have the PGE bit set so
> >	 * __flush_tlb_all() is not yet doing what it says - but
> >	 * accidentally we have a cr3 flush here which is what is
> >	 * needed - so there's no need to add a Quark quirk here.
> >	 */
> >
> >Right?
> 
> OK.
> 
> IMO.
> 
> If we're adding a comment though the first thing the comment ought to say is
> what the code does for everybody else - stuff CR3 and flush the TLB, then it
> should comment on the exception for Quark.
> 
> /*
>  * Locate the page directory and flush the TLB.
>  *
>  * On Quark CPUs we still have the PGE bit set so
>  * __flush_tlb_all() is not yet doing what it says - but
>  * accidentally we have a cr3 flush here which is what is
>  * needed - so there's no need to add a Quark quirk here.
>  */
> 
> ?

Yeah, fair enough. You can even put the latter in parentheses, to 
signal that it's all a rare case.

Thanks,

	Ingo
