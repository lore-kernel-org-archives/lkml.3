Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3KNCH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:07:56 -0500
Received: from mx5.zte.com.cn ([63.217.80.70]:37218 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3KNCHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:07:51 -0500
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2013 21:07:51 EST
Subject: kmod: avoid propagating PF_NO_SETAFFINITY into userspace child
X-KeepSent: C3933D9B:5510E97E-48257C23:0007B7CD;
 type=4; name=$KeepSent
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Thu, 14 Nov 2013 09:51:47 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-11-14 09:51:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse01.zte.com.cn rAE1pxoo019904
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel worker thread has the PF_NO_SETAFFINITY flag, and it is propagated
into the userspace child. Clearing this flag in usersapce child to enable its
migrating capability.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>

--- linux3-12/kernel/kmod.c	2013-11-14 09:06:58.991781656 +0000
+++ linux3-12/kernel/kmod.c	2013-11-14 09:08:47.511781621 +0000
@@ -217,6 +217,7 @@ static int ____call_usermodehelper(void
 	 * Avoid propagating that into the userspace child.
 	 */
 	set_user_nice(current, 0);
+	current->flags &= ~PF_NO_SETAFFINITY;

 	retval = -ENOMEM;
 	new = prepare_kernel_cred(current);

