Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3HVLG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:06:27 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56840 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3HVLGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:06:24 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 16/18] Hibernate: show the verification time for monitor performance
Date: Thu, 22 Aug 2013 19:01:55 +0800
Message-Id: <1377169317-5959-17-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the verification time for monitor the performance of SHA256 and RSA
verification.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/snapshot.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 36c7157..b9c6a8a 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2536,6 +2536,8 @@ error_mpi:
 
 int snapshot_image_verify(void)
 {
+	struct timeval start;
+	struct timeval stop;
 	struct crypto_shash *tfm;
 	struct shash_desc *desc;
 	u8 *digest;
@@ -2563,6 +2565,8 @@ int snapshot_image_verify(void)
 	desc->tfm = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
+	do_gettimeofday(&start);
+
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
 		goto error_shash;
@@ -2581,6 +2585,9 @@ int snapshot_image_verify(void)
 	if (ret)
 		goto error_verify;
 
+	do_gettimeofday(&stop);
+	swsusp_show_speed(&start, &stop, nr_copy_pages, "Verified");
+
 	kfree(h_buf);
 	kfree(digest);
 	crypto_free_shash(tfm);
-- 
1.6.4.2

