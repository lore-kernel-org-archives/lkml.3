Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaI3UKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:10:04 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45306 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaI3UKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:10:02 -0400
Date: Tue, 30 Sep 2014 22:10:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org
Subject: Re: [PATCH 1/2] Use faster check for modules in backtrace on 64bit
Message-ID: <20140930200959.GB8196@two.firstfloor.org>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-2-git-send-email-andi@firstfloor.org>
 <20140929114212.GG5430@worktop>
 <20140929152145.GB1629@tassilo.jf.intel.com>
 <20140929203023.GA8196@two.firstfloor.org>
 <20140930085814.GS5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930085814.GS5430@worktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also I investigated it now, but we don't have RCU support for rbtrees.
> > So it would need some kind of locking for the reader, which is a show
> > stopper.
> 
> Nah, we can trivially do that with a seqlock. Not read side locking
> required in the normal case.

I'm not convinced. It wouldn't surprise me if it was possible
to generate endless cycles with rcu freed memory on some rebalancing
operation. If you think I'm wrong please show working code.

Also please explain clearly for the module maintainers and me
what the problem with my original simple trivially show
to be correct solution is.

Thanks,

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
