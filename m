Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab3BHBKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:10:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584Ab3BHA56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 01/26] digsig: Fix memory leakage in digsig_verify_rsa()
Date: Thu,  7 Feb 2013 16:57:29 -0800
Message-Id: <20130208004627.470836954@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

commit 7810cc1e7721220f1ed2a23ca95113d6434f6dcd upstream.

digsig_verify_rsa() does not free kmalloc'ed buffer returned by
mpi_get_buffer().

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/digsig.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -162,6 +162,8 @@ static int digsig_verify_rsa(struct key
 	memset(out1, 0, head);
 	memcpy(out1 + head, p, l);
 
+	kfree(p);
+
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
 	if (err)
 		goto err;


