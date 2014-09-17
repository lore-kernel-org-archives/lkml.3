Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaIQQre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:47:34 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:55967 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIQQrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:47:32 -0400
Message-ID: <1410972450.2447.25.camel@j-VirtualBox>
Subject: Re: [PATCH v3] locking/rwsem: Avoid double checking before try
 acquiring write lock
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <dbueso@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, jason.low2@hp.com
Date: Wed, 17 Sep 2014 09:47:30 -0700
In-Reply-To: <1410946476.9389.32.camel@linux-t7sj.site>
References: <1410913017.2447.22.camel@j-VirtualBox>
	 <1410946476.9389.32.camel@linux-t7sj.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 11:34 +0200, Davidlohr Bueso wrote:
> On Tue, 2014-09-16 at 17:16 -0700, Jason Low wrote:
> > Commit 9b0fc9c09f1b checks for if there are known active lockers
> > in order to avoid write trylocking using expensive cmpxchg() when
> > it likely wouldn't get the lock.
> 
> Ah, I remember you had this one in your queue for some time :)
> 
> > However, a subsequent patch was added such that we directly
> > check for sem->count == RWSEM_WAITING_BIAS right before trying
> > that cmpxchg(). Thus, commit 9b0fc9c09f1b now just adds overhead.
> > This patch modifies it so that we only do a check for if
> > count == RWSEM_WAITING_BIAS.
> > 
> > Also, add a comment on why we do an "extra check" of count
> > before the cmpxchg().
> 
> heh, so people don't try to remove the "redundant" check!

Right, I've already seen at least 1 such patch  :)

> > Cc: Peter Hurley <peter@hurleysoftware.com>
> > Cc: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Acked-by: Davidlohr Bueso <dave@stgolabs.net>

Thanks!

