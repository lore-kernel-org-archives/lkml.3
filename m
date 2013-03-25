Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3CYMAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab3CYMAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:00:50 -0400
Date: Mon, 25 Mar 2013 12:58:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 2/7] uretprobes: extract fill_page() and trampoline
	implementation
Message-ID: <20130325115820.GA27398@redhat.com>
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
> > @@ -1139,6 +1155,10 @@ static struct xol_area *get_xol_area(void)
> >  	if (!area->page)
> >  		goto free_bitmap;
> >
> > +	/* pre-allocate for return probes */
> > +	set_bit(0, area->bitmap);
> > +	fill_page(area->page, 0, &insn);
>
> sizeof(insn) == UPROBE_SWBP_INSN_SIZE != MAX_UINSN_BYTES. See also the
> comments above.

Sorry, forgot to mention... you also need to update ->slot_count.

Oleg.

