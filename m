Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaIYS2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:28:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52936 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaIYS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:28:19 -0400
Date: Thu, 25 Sep 2014 20:28:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
Message-ID: <20140925182814.GA6854@gmail.com>
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie>
 <20140925045755.GA20431@gmail.com>
 <5423E1F7.5010000@nexus-software.ie>
 <20140925145126.GA4434@gmail.com>
 <54242F17.5010503@nexus-software.ie>
 <20140925151123.GA4864@gmail.com>
 <20140925164911.GD10814@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925164911.GD10814@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Thu, 25 Sep 2014, Ingo Molnar wrote:
> > > If we're adding a comment though the first thing the comment ought to say is
> > > what the code does for everybody else - stuff CR3 and flush the TLB, then it
> > > should comment on the exception for Quark.
> > > 
> > > /*
> > >  * Locate the page directory and flush the TLB.
> > >  *
> > >  * On Quark CPUs we still have the PGE bit set so
> > >  * __flush_tlb_all() is not yet doing what it says - but
> > >  * accidentally we have a cr3 flush here which is what is
> > >  * needed - so there's no need to add a Quark quirk here.
> > >  */
> > > 
> > > ?
> > 
> > Yeah, fair enough. You can even put the latter in parentheses, to 
> > signal that it's all a rare case.
> 
> I'd have mentioned "erratum" there, otherwise people won't understand why
> the PGE bit being set would be a problem in the first place.
> 
> Something like:
> 
> /*
>  * Locate the page directory and flush the TLB.
>  *
>  * On Quark X1000 CPUs we still have the PGE bit incorrectly set
>  * due to a processor erratum, so __flush_tlb_all() is not yet
>  * doing what it says.  Fortunately we have a cr3 flush here,
>  * which is what is needed in this processor to flush TLBs, so
>  * there's no need to add a Quark X1000 quirk here.
>  */

Yeah.

I'd also add the fact that it's an unintended erratum to the 
Quark quirk section of early_init_intel() as well.

Thanks,

	Ingo
