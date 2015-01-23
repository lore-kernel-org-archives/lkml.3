Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbbAWRma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:42:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbbAWRm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:42:28 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@atsec.com>
Subject: [PATCH] crypto/testmgr: mark rfc4106(gcm(aes)) as fips_allowed
Date: Fri, 23 Jan 2015 12:42:15 -0500
Message-Id: <1422034935-25537-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gcm variant is popular for ipsec use, and there are folks who would
like to use it while in fips mode. Mark it with fips_allowed=1 to
facilitate that.

CC: LKML <linux-kernel@vger.kernel.org>
CC: Stephan Mueller <smueller@atsec.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 crypto/testmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 235b1ff..758d028 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3293,6 +3293,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "rfc4106(gcm(aes))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
-- 
1.8.3.1

