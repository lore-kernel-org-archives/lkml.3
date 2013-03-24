Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3CXSXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 14:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab3CXSXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 14:23:11 -0400
Date: Sun, 24 Mar 2013 19:20:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 0/5] kmap cleanups for uretprobes (Was: extract fill_page()
	and trampoline implementation)
Message-ID: <20130324182040.GA13078@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-3-git-send-email-anton@redhat.com> <20130324144144.GA17037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324144144.GA17037@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Oleg Nesterov wrote:
>
> On 03/22, Anton Arapov wrote:
> >
> > +static void fill_page(struct page *page, unsigned long offset, uprobe_opcode_t *insn)
>                                                                   ^^^^^^^^^^^^^^^
> Well, it should be "u8 *insn" or "char *".

Or void*.

And we have another reason for this helper.

And I really think that we need to cleanup the kmap mess in uprobe.c
before we add the new abuser.

How about this simple series?

> sizeof(insn) == UPROBE_SWBP_INSN_SIZE != MAX_UINSN_BYTES. See also the
> comments above.

I think that copy_to_page() added by 4/5 is what you need, and it solves
the problems with typeof/sizeof. Plus it have another caller.

Oleg.

