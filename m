Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbaKSWKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:10:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbaKSVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.17 140/141] KEYS: Reinstate EPERM for a key type name beginning with a .
Date: Wed, 19 Nov 2014 12:52:43 -0800
Message-Id: <20141119205155.565623352@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 54e2c2c1a9d6cbb270b0999a38545fa9a69bee43 upstream.

Reinstate the generation of EPERM for a key type name beginning with a '.' in
a userspace call.  Types whose name begins with a '.' are internal only.

The test was removed by:

	commit a4e3b8d79a5c6d40f4a9703abf7fe3abcc6c3b8d
	Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
	Date:   Thu May 22 14:02:23 2014 -0400
	Subject: KEYS: special dot prefixed keyring name bug fix

I think we want to keep the restriction on type name so that userspace can't
add keys of a special internal type.

Note that removal of the test causes several of the tests in the keyutils
testsuite to fail.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/keyctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -37,6 +37,8 @@ static int key_get_type_from_user(char *
 		return ret;
 	if (ret == 0 || ret >= len)
 		return -EINVAL;
+	if (type[0] == '.')
+		return -EPERM;
 	type[len - 1] = '\0';
 	return 0;
 }


