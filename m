Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaKPTfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:35:19 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:62909 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105AbaKPTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:35:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,398,1413237600"; 
   d="scan'208";a="107403827"
Date: Sun, 16 Nov 2014 20:34:59 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Steven Rostedt <rostedt@goodmis.org>
cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 2/2] kernel-trace: Less calls for iput() in
 create_trace_uprobe() after error detection
In-Reply-To: <20141116143120.44421df2@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1411162034190.2364@hadrien>
References: <5307CAA2.8060406@users.sourceforge.net> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
 <5468ABBD.6000903@users.sourceforge.net> <alpine.DEB.2.10.1411161656340.2364@hadrien> <5468F756.8070807@users.sourceforge.net> <5468F96E.4090903@users.sourceforge.net> <20141116143120.44421df2@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2014, Steven Rostedt wrote:

> On Sun, 16 Nov 2014 20:22:22 +0100
> SF Markus Elfring <elfring@users.sourceforge.net> wrote:
>
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Sun, 16 Nov 2014 19:49:39 +0100
> >
> > The iput() function was called in three cases by the create_trace_uprobe()
> > function during error handling even if the passed variable contained still
> > a null pointer. This implementation detail could be improved by the
> > introduction of another jump label.
>
> The first patch is fine, and the only reason is to save the few bytes
> that the branch check might take. It's in a path that is unlikely to be
> hit so it is not a performance issue at all.
>
> This patch is useless. I rather not apply any patch than to create
> another jump that skips over the freeing of iput() just because we know
> inode is null. That's why we had the if (inode) in the first place.
>
> So Nack on this patch and I'll contemplate applying the first one. I
> probably will as it seems rather harmless.

I wuold have thought that one could have just returned, like in the cases
above...  But maybe the printed message is useful.

julia
