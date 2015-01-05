Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbbAEWB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:01:59 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60363 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbbAEWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:01:58 -0500
X-IronPort-AV: E=Sophos;i="5.07,702,1413237600"; 
   d="scan'208";a="115765956"
Date: Mon, 5 Jan 2015 23:01:55 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] fs/9p: Deletion of unnecessary checks before the
 function call "p9_client_clunk"
In-Reply-To: <54AB0844.5090405@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1501052257270.2025@localhost6.localdomain6>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net> <54A06AB9.4020505@users.sourceforge.net> <20150105112206.GC15033@mwanda>
 <54AB02F3.5020308@users.sourceforge.net> <alpine.DEB.2.02.1501052239290.2025@localhost6.localdomain6> <54AB0844.5090405@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The error response is clear. Are any software developments efforts expected
> to clean-up the call stack for unwanted null pointers even more?

I found the original patch and looked at the call sites.  None of them 
calls dump_stack.  The behavior is thus not the same.  With your change, 
something that was previously treated in an orderly manner will be 
converted to something that looks like an oops.  I assume that the cost of 
the dump_stack will also be huge.

julia
