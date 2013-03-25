Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3CYMdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab3CYMds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:33:48 -0400
Date: Mon, 25 Mar 2013 13:31:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 5/7] uretprobes: return probe exit, invoke handlers
Message-ID: <20130325123121.GA28660@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-6-git-send-email-anton@redhat.com> <20130324162817.GD17037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324162817.GD17037@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last comment, I promise ;)

On 03/24, Oleg Nesterov wrote:
>
> On 03/22, Anton Arapov wrote:
> >
> > +static void handle_uretprobe(struct xol_area *area, struct pt_regs *regs)
> > +{
> > +	struct uprobe_task *utask;
> > +	struct return_instance *ri, *tmp;
> > +	unsigned long prev_ret_vaddr;
> > +
> > +	utask = get_utask();
> > +	if (!utask)
> > +		return;
> > +
> > +	ri = utask->return_instances;
> > +	if (!ri)
> > +		return;
>
> Hmm. I am wondering what should the caller (handle_swbp) do in this
> case...

And you do not actually need get_utask(), just check current->utask.

handle_uretprobe() must not be called if either ->utask or
->return_instances is NULL. This can only happen if we have a bug,
or user-space tries to fool the kernel.

Perhaps it makes sense to add pr_warn().

Oleg.

