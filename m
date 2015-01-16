Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbbAPC2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:28:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:30848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbbAPC2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:28:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="441198292"
Date: Fri, 16 Jan 2015 10:27:32 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Michael Halcrow <mhalcrow@google.com>
Cc: kbuild-all@01.org, "Theodore Ts'o" <tytso@mit.edu>,
        Uday Savagaonkar <savagaon@google.com>,
        Ildar Muslukhov <ildarm@google.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH ext4] ext4 crypto: ext4_fname_decrypt() can be static
Message-ID: <20150116022732.GA55041@snb>
References: <201501161021.CZOoWii2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501161021.CZOoWii2%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/ext4/crypto_fname.c:322:5: sparse: symbol 'ext4_fname_decrypt' was not declared. Should it be static?
fs/ext4/crypto_fname.c:380:5: sparse: symbol 'ext4_fname_encode_digest' was not declared. Should it be static?
fs/ext4/crypto_fname.c:479:6: sparse: symbol 'ext4_free_fname_crypto_ctx' was not declared. Should it be static?
fs/ext4/crypto_fname.c:532:30: sparse: symbol 'ext4_alloc_fname_crypto_ctx' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 crypto_fname.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index e1a72d1..4b4b507 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -319,7 +319,7 @@ static int ext4_fname_encrypt(struct ext4_fname_crypto_ctx *ctx,
  *	Errors are returned as negative numbers.
  *	We trust the caller to allocate sufficient memory to oname string.
  */
-int ext4_fname_decrypt(struct ext4_fname_crypto_ctx *ctx,
+static int ext4_fname_decrypt(struct ext4_fname_crypto_ctx *ctx,
 		       struct ext4_cstr *oname,
 		       const struct ext4_cstr *iname)
 {
@@ -377,7 +377,7 @@ int ext4_fname_decrypt(struct ext4_fname_crypto_ctx *ctx,
  * Encodes the input digest using characters from the set [a-zA-Z0-9_+].
  * The encoded string is roughly 4/3 times the size of the input string.
  */
-int ext4_fname_encode_digest(char *dst, char *src, u32 len)
+static int ext4_fname_encode_digest(char *dst, char *src, u32 len)
 {
 	static const char *lookup_table =
 		"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_+";
@@ -476,7 +476,7 @@ out:
  *
  * Frees up a crypto context.
  */
-void ext4_free_fname_crypto_ctx(struct ext4_fname_crypto_ctx *ctx)
+static void ext4_free_fname_crypto_ctx(struct ext4_fname_crypto_ctx *ctx)
 {
 	if (ctx == NULL || IS_ERR(ctx))
 		return;
@@ -529,7 +529,7 @@ static struct ext4_fname_crypto_ctx *ext4_search_fname_crypto_ctx(
 /**
  * ext4_alloc_fname_crypto_ctx() -
  */
-struct ext4_fname_crypto_ctx *ext4_alloc_fname_crypto_ctx(
+static struct ext4_fname_crypto_ctx *ext4_alloc_fname_crypto_ctx(
 	const struct ext4_encryption_key *key)
 {
 	struct ext4_fname_crypto_ctx *ctx;
