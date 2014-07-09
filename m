Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbaGIPSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbaGIPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:25 -0400
Subject: [PATCH15/17] pefile: Handle pesign using the wrong OID
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:17:02 +0100
Message-ID: <20140709151702.23074.15597.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pesign utility had a bug where it was using OID_msIndividualSPKeyPurpose
instead of OID_msPeImageDataObjId - so allow both OIDs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/mscode_parser.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
index 09336c3..214a992 100644
--- a/crypto/asymmetric_keys/mscode_parser.c
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -58,7 +58,13 @@ int mscode_note_content_type(void *context, size_t hdrlen,
 		return -EBADMSG;
 	}
 
-	if (oid != OID_msIndividualSPKeyPurpose) {
+	/*
+	 * pesign utility had a bug where it was putting
+	 * OID_msIndividualSPKeyPurpose instead of OID_msPeImageDataObjId
+	 * So allow both OIDs.
+	 */
+	if (oid != OID_msPeImageDataObjId &&
+	    oid != OID_msIndividualSPKeyPurpose) {
 		pr_err("Unexpected content type OID %u\n", oid);
 		return -EBADMSG;
 	}

