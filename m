Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749Ab3DGXj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:39:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46671 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934628Ab3DGX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:29:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Cox" <alan@linux.intel.com>,
        "David Howells" <dhowells@redhat.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.185082284@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [48/74] key: Fix resource leak
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit a84a921978b7d56e0e4b87ffaca6367429b4d8ff upstream.

On an error iov may still have been reallocated and need freeing

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/keys/keyctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1067,12 +1067,12 @@ long keyctl_instantiate_key_iov(key_seri
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

