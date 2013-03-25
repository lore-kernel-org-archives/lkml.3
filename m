Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3CYKar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab3CYKaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:30:46 -0400
Date: Mon, 25 Mar 2013 11:30:24 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 0/5] kmap cleanups for uretprobes (Was: extract
 fill_page() and trampoline implementation)
Message-ID: <20130325103024.GA8163@bandura.brq.redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
 <1363957745-6657-3-git-send-email-anton@redhat.com>
 <20130324144144.GA17037@redhat.com>
 <20130324182040.GA13078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182040.GA13078@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 07:20:40PM +0100, Oleg Nesterov wrote:
> On 03/24, Oleg Nesterov wrote:
> >
> > On 03/22, Anton Arapov wrote:
> > >
> > > +static void fill_page(struct page *page, unsigned long offset, uprobe_opcode_t *insn)
> >                                                                   ^^^^^^^^^^^^^^^
> > Well, it should be "u8 *insn" or "char *".
> 
> Or void*.
> 
> And we have another reason for this helper.
> 
> And I really think that we need to cleanup the kmap mess in uprobe.c
> before we add the new abuser.
> 
> How about this simple series?
> 
> > sizeof(insn) == UPROBE_SWBP_INSN_SIZE != MAX_UINSN_BYTES. See also the
> > comments above.
> 
> I think that copy_to_page() added by 4/5 is what you need, and it solves
> the problems with typeof/sizeof. Plus it have another caller.

That's what I can't come up with. My fill_page() was indeed ugly. 

Thanks!
Anton.

> Oleg.
> 
