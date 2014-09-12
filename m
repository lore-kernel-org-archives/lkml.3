Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaILJ4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:56:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaILJ4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:56:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] TPM: Add new TPMs to the tail of the list to prevent
 inadvertent change of dev
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>
Date: Fri, 12 Sep 2014 10:55:35 +0100
Message-ID: <20140912095535.9166.60056.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add newly registered TPMs to the tail of the list, not the beginning, so that
things that are specifying TPM_ANY_NUM don't find that the device they're
using has inadvertently changed.  Adding a second device would break IMA, for
instance.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
cc: stable@vger.kernel.org
---

 drivers/char/tpm/tpm-interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6af17002a115..cfb9089887bd 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1122,7 +1122,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 
 	/* Make chip available */
 	spin_lock(&driver_lock);
-	list_add_rcu(&chip->list, &tpm_chip_list);
+	list_add_tail_rcu(&chip->list, &tpm_chip_list);
 	spin_unlock(&driver_lock);
 
 	return chip;

