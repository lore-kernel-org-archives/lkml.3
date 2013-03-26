Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3CZW6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:58:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3CZWwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, David Howells <dhowells@redhat.com>
Subject: [ 65/72] key: Fix resource leak
Date: Tue, 26 Mar 2013 15:51:48 -0700
Message-Id: <20130326224926.370204974@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit a84a921978b7d56e0e4b87ffaca6367429b4d8ff upstream.

On an error iov may still have been reallocated and need freeing

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/keyctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1081,12 +1081,12 @@ long keyctl_instantiate_key_iov(key_seri
 	ret = rw_copy_check_uvector(WRITE, _payload_iov, ioc,
 				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
 	if (ret < 0)
-		return ret;
+		goto err;
 	if (ret == 0)
 		goto no_payload_free;
 
 	ret = keyctl_instantiate_key_common(id, iov, ioc, ret, ringid);
-
+err:
 	if (iov != iovstack)
 		kfree(iov);
 	return ret;


