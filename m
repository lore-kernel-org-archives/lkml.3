Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3KJQ61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:58:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3KJQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:58:26 -0500
Date: Sun, 10 Nov 2013 17:59:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] list: introduce list_next/prev_entry
Message-ID: <20131110165947.GA32758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Not sure who maintains list.h, hopefully this is -mm material.

It is really annoying that we do not have list_next/prev_entry,
they can have a lot of users, including list.h itself.

And in fact list_next_entry() is already defined in events/core.c
and bnx2x_sp.c, this proves that it is really handy. That is why
1/4 comes as a separate patch because it touches the code outside
of list.h.

3/4 is minor, but I think makes sense anyway.

4/4 is just the random example of usage outside of list.h,
list_entry(child->d_u.d_child.next, struct dentry, d_u.d_child)
is hardly readable.

None of this patches changes the compiled code.

Oleg.

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |    3 -
 fs/debugfs/inode.c                             |    3 +-
 include/linux/list.h                           |   79 ++++++++++++++++--------
 kernel/events/core.c                           |    3 -
 4 files changed, 54 insertions(+), 34 deletions(-)

