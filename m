Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaIYQtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:49:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50793 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbaIYQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:49:24 -0400
X-Sasl-enc: kzzNkJ7rhx17cqI/HvtZ3WhIesiCojnxuYZaqk6fUsx9 1411663763
Date: Thu, 25 Sep 2014 13:49:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
Message-ID: <20140925164911.GD10814@khazad-dum.debian.net>
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie>
 <20140925045755.GA20431@gmail.com>
 <5423E1F7.5010000@nexus-software.ie>
 <20140925145126.GA4434@gmail.com>
 <54242F17.5010503@nexus-software.ie>
 <20140925151123.GA4864@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925151123.GA4864@gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Ingo Molnar wrote:
> > If we're adding a comment though the first thing the comment ought to say is
> > what the code does for everybody else - stuff CR3 and flush the TLB, then it
> > should comment on the exception for Quark.
> > 
> > /*
> >  * Locate the page directory and flush the TLB.
> >  *
> >  * On Quark CPUs we still have the PGE bit set so
> >  * __flush_tlb_all() is not yet doing what it says - but
> >  * accidentally we have a cr3 flush here which is what is
> >  * needed - so there's no need to add a Quark quirk here.
> >  */
> > 
> > ?
> 
> Yeah, fair enough. You can even put the latter in parentheses, to 
> signal that it's all a rare case.

I'd have mentioned "erratum" there, otherwise people won't understand why
the PGE bit being set would be a problem in the first place.

Something like:

/*
 * Locate the page directory and flush the TLB.
 *
 * On Quark X1000 CPUs we still have the PGE bit incorrectly set
 * due to a processor erratum, so __flush_tlb_all() is not yet
 * doing what it says.  Fortunately we have a cr3 flush here,
 * which is what is needed in this processor to flush TLBs, so
 * there's no need to add a Quark X1000 quirk here.
 */

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
