Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3BFIop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:44:45 -0500
Received: from intranet.asianux.com ([58.214.24.6]:31958 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3BFIoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:44:44 -0500
X-Spam-Score: -100.8
Message-ID: <511217F3.6050800@asianux.com>
Date: Wed, 06 Feb 2013 16:44:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: akpm@linux-foundation.org, keescook@chromium.org,
        serge.hallyn@canonical.com, gorcunov@openvz.org, ebiederm@xmission.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: arg2 is unsigned long which is never < 0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  arg2 will never < 0, for its type is 'unsigned long'

  so delete the waste code.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 24d1ef5..568b9ca 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2027,7 +2027,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = get_dumpable(me->mm);
 			break;
 		case PR_SET_DUMPABLE:
-			if (arg2 < 0 || arg2 > 1) {
+			if (arg2 > 1) {
 				error = -EINVAL;
 				break;
 			}
-- 
1.7.7.6
