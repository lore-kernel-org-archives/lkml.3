Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3KDOXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:23:21 -0500
Received: from [107.14.166.225] ([107.14.166.225]:62518 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753699Ab3KDOXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:23:18 -0500
Date: Mon, 4 Nov 2013 09:22:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] trace/trace_stat: use rbtree postorder iteration
 helper instead of opencoding
Message-ID: <20131104092235.5109bd94@gandalf.local.home>
In-Reply-To: <52775F91.5070305@linux.vnet.ibm.com>
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
	<1383345566-25087-2-git-send-email-cody@linux.vnet.ibm.com>
	<20131101224538.7fe04ba8@gandalf.local.home>
	<52775F91.5070305@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Nov 2013 00:49:21 -0800
Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> On 11/01/2013 07:45 PM, Steven Rostedt wrote:
> > On Fri,  1 Nov 2013 15:38:46 -0700
> > Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> >
> >> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
> >> of opencoding an alternate postorder iteration that modifies the tree
> >>
> >> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> >> ---
> >>   kernel/trace/trace_stat.c | 42 ++++++------------------------------------
> >>   1 file changed, 6 insertions(+), 36 deletions(-)
> >>
> 
> >> +	rbtree_postorder_for_each_entry_safe(snode, n, &session->stat_root,
> >> +			node) {
> >
> > This is one of those cases that a line break is uglier than keeping it
> > on the same line. Heck, it's only 4 characters over the 80 char limit.
> >
> 
> I'm fine with that being tweaked.
> 
> > Other than that, I'm fine with this patch. Want me to take this
> > separately?
> >
> 
> The patches in this patchset are all independent (they just happen to be 
> making nearly identical changes throughout the tree), so feel free.
> 

OK, I'll pull it in and modify the above change too.

Thanks,

-- Steve
