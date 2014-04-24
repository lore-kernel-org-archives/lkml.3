Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbaDXEcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:32:03 -0400
Received: from ozlabs.org ([103.22.144.67]:43793 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaDXEcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:32:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Greg KH" <greg@kroah.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, Kirk Reiser <kirk@braille.uwo.ca>,
        Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] speakup: fix incorrect perms on speakup_acntsa.c
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Apr 2014 13:59:53 +0930
Message-ID: <878uqvfiym.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22c9bcad859d5c969289b3b37084a96c621f8f2c contained a bad
substitution for ROOT_W => S_IRUSR|S_IRUGO instead of
S_IWUSR|S_IRUGO.

Fixes: 22c9bcad859d5c969289b3b37084a96c621f8f2c
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/staging/speakup/speakup_acntsa.c b/drivers/staging/speakup/speakup_acntsa.c
index c7f014ed9628..5079dbd5d7ad 100644
--- a/drivers/staging/speakup/speakup_acntsa.c
+++ b/drivers/staging/speakup/speakup_acntsa.c
@@ -60,15 +60,15 @@ static struct kobj_attribute vol_attribute =
 	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
 	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
