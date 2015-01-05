Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbbAEVl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:41:58 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51713
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbbAEVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:41:57 -0500
X-IronPort-AV: E=Sophos;i="5.07,702,1413237600"; 
   d="scan'208";a="95411293"
Date: Mon, 5 Jan 2015 22:41:52 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] fs/9p: Deletion of unnecessary checks before the
 function call "p9_client_clunk"
In-Reply-To: <54AB02F3.5020308@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1501052239290.2025@localhost6.localdomain6>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net> <54A06AB9.4020505@users.sourceforge.net> <20150105112206.GC15033@mwanda>
 <54AB02F3.5020308@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2015, SF Markus Elfring wrote:

> >> The p9_client_clunk() function tests whether its argument is NULL
> >> and then returns immediately. Thus the test around the call is not needed.
> >>
> > 
> > Not true.  You are not allowed to call p9_client_clunk(NULL).
> 
> I find that it will work in principle if we refer to the same
> function implementation.
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/net/9p/client.c?id=d8282ea05ad119247122de23db7d48ad6098cfa2#n1448
> http://lxr.free-electrons.com/source/net/9p/client.c#L1448

What do you mean by "work in principle"?  One possible issue is the return 
value - I don't have the original patch so I don't know what is the call 
site, so I don't know if that is an issue.  But you don't want to do a 
dump_stack for no reason.  That would at best be very misleading, and I 
would imagine be quite expensive.

julia
