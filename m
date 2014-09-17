Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaIQJgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:36:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbaIQJgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:36:47 -0400
Message-ID: <1410946476.9389.32.camel@linux-t7sj.site>
Subject: Re: [PATCH v3] locking/rwsem: Avoid double checking before try
 acquiring write lock
From: Davidlohr Bueso <dbueso@suse.de>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>
Date: Wed, 17 Sep 2014 11:34:37 +0200
In-Reply-To: <1410913017.2447.22.camel@j-VirtualBox>
References: <1410913017.2447.22.camel@j-VirtualBox>
Organization: SUSE Labs
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 17:16 -0700, Jason Low wrote:
> Commit 9b0fc9c09f1b checks for if there are known active lockers
> in order to avoid write trylocking using expensive cmpxchg() when
> it likely wouldn't get the lock.

Ah, I remember you had this one in your queue for some time :)

> However, a subsequent patch was added such that we directly
> check for sem->count == RWSEM_WAITING_BIAS right before trying
> that cmpxchg(). Thus, commit 9b0fc9c09f1b now just adds overhead.
> This patch modifies it so that we only do a check for if
> count == RWSEM_WAITING_BIAS.
> 
> Also, add a comment on why we do an "extra check" of count
> before the cmpxchg().

heh, so people don't try to remove the "redundant" check!

> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

> Signed-off-by: Jason Low <jason.low2@hp.com>

