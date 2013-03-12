Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab3CLWe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:34:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab3CLWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 099/100] Revert "xen/blkback: Dont trust the handle from the frontend."
Date: Tue, 12 Mar 2013 15:32:24 -0700
Message-Id: <20130312223133.487882028@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 01c681d4c70d64cb72142a2823f27c4146a02e63 upstream
(ef56ca64ea733c3b88f0bb74b04da128b1dc35d8 in this tree), as it wasn't
supposed to have been applied to the stable tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

---
 drivers/block/xen-blkback/blkback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -881,6 +881,7 @@ static int dispatch_rw_block_io(struct x
 		goto fail_response;
 	}
 
+	preq.dev           = req->u.rw.handle;
 	preq.sector_number = req->u.rw.sector_number;
 	preq.nr_sects      = 0;
 


