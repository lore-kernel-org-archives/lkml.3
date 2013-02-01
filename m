Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3BAFZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 00:25:30 -0500
Received: from tundra.namei.org ([65.99.196.166]:42937 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3BAFZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 00:25:28 -0500
Date: Fri, 1 Feb 2013 16:21:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT][LIB] Fix memory leak in digital signature library
Message-ID: <alpine.LRH.2.02.1302011620190.8934@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.


The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:
  Linus Torvalds (1):
        Linux 3.8-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

YOSHIFUJI Hideaki (1):
      digsig: Fix memory leakage in digsig_verify_rsa()

 lib/digsig.c |    2 ++
 1 file changed, 2 insertions(+)

commit 7810cc1e7721220f1ed2a23ca95113d6434f6dcd
Author: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date:   Fri Jan 25 16:54:20 2013 +0200

    digsig: Fix memory leakage in digsig_verify_rsa()
    
    digsig_verify_rsa() does not free kmalloc'ed buffer returned by
    mpi_get_buffer().
    
    Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/lib/digsig.c b/lib/digsig.c
index 8c0e629..dc2be7e 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -162,6 +162,8 @@ static int digsig_verify_rsa(struct key *key,
 	memset(out1, 0, head);
 	memcpy(out1 + head, p, l);
 
+	kfree(p);
+
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
 	if (err)
 		goto err;
