Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbbANCRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:17:07 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:17028 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbbANCRG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:17:06 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'rusty@rustcorp.com.au'" <rusty@rustcorp.com.au>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'jani.nikula@intel.com'" <jani.nikula@intel.com>,
        "'hch@infradead.org'" <hch@infradead.org>,
        "'hare@suse.de'" <hare@suse.de>,
        "'keescook@chromium.org'" <keescook@chromium.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jan 2015 10:16:59 +0800
Subject: [RFC] export module parameters even the permission is zero
Thread-Topic: [RFC] export module parameters even the permission is zero
Thread-Index: AdAvoC1CY/UkqYNrQKyua18hCR6MiA==
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E1A3@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make sure to export module parameters even the permission
is zero, this is useful for some platforms like Android,
the init process can change the parameter mode/owner by
chmod/chown during bootup

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 kernel/params.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index bd65d136..aa80c04 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -607,9 +607,6 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 	struct attribute **new_attrs;
 	unsigned int i;
 
-	/* We don't bother calling this with invisible parameters. */
-	BUG_ON(!kp->perm);
-
 	if (!mk->mp) {
 		/* First allocation. */
 		mk->mp = kzalloc(sizeof(*mk->mp), GFP_KERNEL);
@@ -812,9 +809,6 @@ static void __init param_sysfs_builtin(void)
 	for (kp = __start___param; kp < __stop___param; kp++) {
 		char *dot;
 
-		if (kp->perm == 0)
-			continue;
-
 		dot = strchr(kp->name, '.');
 		if (!dot) {
 			/* This happens for core_param() */
-- 
2.1.3
