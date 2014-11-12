Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaKLPzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:55:09 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:41437 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaKLPzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:55:06 -0500
MIME-Version: 1.0
Date: Wed, 12 Nov 2014 15:55:05 +0000
Message-ID: <CAE9SfeNcWAeTt6Q+7our_c_TKDOL14VoAbiASjHLA8+orTMouQ@mail.gmail.com>
Subject: PATCH kernel/acct.c to fix compiler warning
From: Brian Haslett <knotwurk@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the warning:
kernel/acct.c: In function 'do_acct_process':
kernel/acct.c:475:24: warning: unused variable 'ns' [-Wunused-variable]
  struct pid_namespace *ns = acct->ns;

and this is the patch:

Signed-off-by: Brian P. Haslett <knotwurk@gmail.com>
--- a/kernel/acct.c 2014-11-11 10:25:49.000000000 +0000
+++ b/kernel/acct.c 2014-11-11 10:25:40.000000000 +0000
@@ -472,7 +472,9 @@ static void do_acct_process(struct bsd_a
    acct_t ac;
    unsigned long flim;
    const struct cred *orig_cred;
+#if ACCT_VERSION == 3
    struct pid_namespace *ns = acct->ns;
+#endif
    struct file *file = acct->file;

    /*
