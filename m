Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3EII4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:56:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51747
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab3EII4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:56:05 -0400
Date: Thu, 9 May 2013 10:54:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] liblockdep: userspace lockdep
Message-ID: <20130509085429.GA3039@dyad.programming.kicks-ass.net>
References: <1368073156-27567-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368073156-27567-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:19:07AM -0400, Sasha Levin wrote:
> liblockdep is a tiny wrapper built around kernel/lockdep.c. The aim is to
> provide the same functionality the kernel gets from lockdep to userspace.
> 
> The bulk of the code here is the LD_PRELOAD support which provides users
> an easy way to test their code without having to integrate liblockdep into
> said code. Simply doing:
> 
>         lockdep my_app
> 
> 	Would provide lockdep support to my_app.
> 
> 	There is also a small test suite to test both mutexes and rwlocks, it's
> 	based on the tests in lib/locking-selftest.c.
> 
> 	This entire patch series was reviewed by lockdep maintainers and accepted to
> 	the tip tree previously. It was pulled out so that the potential merge of
> 	liblockdep won't delay the rest of the commits in the tip locking tree.
> 
> 	For some more background about this entire thing, the folks at LWN did
> 	an awesome overview: http://lwn.net/Articles/536363/
> 
> 
> Changes from v1:
>  - Addressed Peter's comments.
> 

root@twins:/usr/src/linux-2.6/tools/lib/lockdep# make
  CC FPIC            common.o
In file included from ./uinclude/linux/lockdep.h:13:0,
                 from /usr/src/linux-2.6/tools/lib/lockdep/common.c:4:
./../../../include/linux/lockdep.h:21:27: fatal error: linux/linkage.h: No such file or directory
compilation terminated.
make: *** [common.o] Error 1

