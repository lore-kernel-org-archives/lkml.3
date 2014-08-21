Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaHUV6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:58:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaHUV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:58:45 -0400
Date: Thu, 21 Aug 2014 14:58:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: delete double assignment
Message-Id: <20140821145844.a661662c0823ec930ae39a6f@linux-foundation.org>
In-Reply-To: <20140728152632.GA2926@himangi-Dell>
References: <20140728152632.GA2926@himangi-Dell>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014 20:56:32 +0530 Himangi Saraogi <himangi774@gmail.com> wrote:

> Delete successive assignments to the same location. The two assignments are
> simply identical.
> 
> A simplified version of Coccinelle semantic match that finds this problem is as
> follows:
> 
> // <smpl>
> @@
> expression i;
> @@
> 
> *i = ...;
>  i = ...;
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> Should the fist assignment be initializing the pv_minor field?

I'd say so, yes.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/ocfs2/stack_user.c: fix typo in ocfs2_control_release()

It is supposed to zero pv_minor.

Reported-by: Himangi Saraogi <himangi774@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/stack_user.c~fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release
+++ a/fs/ocfs2/stack_user.c
@@ -591,7 +591,7 @@ static int ocfs2_control_release(struct
 		 */
 		ocfs2_control_this_node = -1;
 		running_proto.pv_major = 0;
-		running_proto.pv_major = 0;
+		running_proto.pv_minor = 0;
 	}
 
 out:
_

