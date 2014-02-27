Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaB0MU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:20:29 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54584 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0MU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:20:28 -0500
Date: Thu, 27 Feb 2014 17:50:19 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Schichan <nschichan@freebox.fr>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        James Morris <james.l.morris@oracle.com>, josh@joshtriplett.org
Subject: [PATCH 35/46] kernel: Mark function as static in kernel/seccomp.c
Message-ID: <76266614ae965cacc59033bd20385fbcf6393770.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in kernel/seccomp.c because it is not used
outside this file.

This eliminates the following warning in kernel/seccomp.c:
kernel/seccomp.c:296:6: warning: no previous prototype for ‘seccomp_attach_user_filter’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/seccomp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b7a1004..0e004a7 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -293,7 +293,7 @@ fail:
  *
  * Returns 0 on success and non-zero otherwise.
  */
-long seccomp_attach_user_filter(char __user *user_filter)
+static long seccomp_attach_user_filter(char __user *user_filter)
 {
 	struct sock_fprog fprog;
 	long ret = -EFAULT;
-- 
1.7.9.5

