Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3FYP1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:27:07 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33260 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FYP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:27:05 -0400
Date: Tue, 25 Jun 2013 17:27:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Message-ID: <20130625152703.GZ6123@two.firstfloor.org>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBRkE8z54a1gY00tmYkJ-4KHVv5XyLhvTCOUsDKVcQfP5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRkE8z54a1gY00tmYkJ-4KHVv5XyLhvTCOUsDKVcQfP5w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The LBR call stack has following known limitations
> >  1. Zero length calls are not filtered out by hardware
> >  2. Exception handing such as setjmp/longjmp will have calls/returns not
> >     match
> >  3. Pushing different return address onto the stack will have calls/returns
> >     not match
> >
> I would also add that it does not work with leaf call optimizations:
> A calls B, B calls C, C returns to A

For this case it works as well as frame pointer or dwarf (or any
other backtracer), they simply do not show up in the callgraph
(unless you disable the tail calls). 

I wouldn't consider it an additional limitation.

Another case that doesn't work with is TSX transactions.

Still it's extremly useful if you have nothing else ...

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
