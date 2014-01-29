Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaA2SQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:16:57 -0500
Received: from nautica.notk.org ([91.121.71.147]:49538 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaA2SQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:16:56 -0500
Date: Wed, 29 Jan 2014 19:16:39 +0100
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Eric Van Hensbergen <ericvh@gmail.com>, linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH] 9P: Add memory barriers to protect
 request fields over cb/rpc threads handoff
Message-ID: <20140129181639.GA19138@nautica>
References: <1389979860-7821-1-git-send-email-dominique.martinet@cea.fr>
 <1389979860-7821-2-git-send-email-dominique.martinet@cea.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389979860-7821-2-git-send-email-dominique.martinet@cea.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dominique Martinet wrote on Fri, Jan 17, 2014 :
> We need barriers to guarantee this pattern works as intended:
> [w] req->rc, 1		[r] req->status, 1
> wmb			rmb
> [w] req->status, 1	[r] req->rc
> 
> Where the wmb ensures that rc gets written before status,
> and the rmb ensures that if you observe status == 1, rc is the new value.
> 
> Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
> ---
>  include/net/9p/client.h |  2 +-
>  net/9p/client.c         | 16 +++++++++++++++-
>  net/9p/trans_fd.c       | 15 ++++++---------
>  net/9p/trans_rdma.c     |  3 +--
>  net/9p/trans_virtio.c   |  3 +--
>  5 files changed, 24 insertions(+), 15 deletions(-)

Reminder to get some attention now that the pull request for merge
window has passed :)
Please ask if this needs a resend, but should still apply as is.


Would be particularily nice to get confirmation that this doesn't slow
everything down for tcp/virtio folk or raises another kind of blocker
(although I have nothing better short of another transport-specific
function call after the p9_client_rpc wait is over, which is worse than
this to me, but suggestions are always welcome!)

Cheers,
-- 
Dominique Martinet
