Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaEDPur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:50:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbaEDPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.4 18/43] nfsd4: fix test_stateid error reply encoding
Date: Sun,  4 May 2014 11:42:12 -0400
Message-Id: <20140504154226.711442728@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a11fcce1544df08c723d950ff0edef3adac40405 upstream.

If the entire operation fails then there's nothing to encode.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3408,6 +3408,9 @@ nfsd4_encode_test_stateid(struct nfsd4_c
 	struct nfsd4_test_stateid_id *stateid, *next;
 	__be32 *p;
 
+	if (nfserr)
+		return nfserr;
+
 	RESERVE_SPACE(4 + (4 * test_stateid->ts_num_ids));
 	*p++ = htonl(test_stateid->ts_num_ids);
 


