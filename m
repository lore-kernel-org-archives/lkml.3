Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3CAUDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:03:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3CATqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 17/46] xen/blkback: Dont trust the handle from the frontend.
Date: Fri,  1 Mar 2013 11:45:05 -0800
Message-Id: <20130301194434.062149548@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 01c681d4c70d64cb72142a2823f27c4146a02e63 upstream.

The 'handle' is the device that the request is from. For the life-time
of the ring we copy it from a request to a response so that the frontend
is not surprised by it. But we do not need it - when we start processing
I/Os we have our own 'struct phys_req' which has only most essential
information about the request. In fact the 'vbd_translate' ends up
over-writing the preq.dev with a value from the backend.

This assignment of preq.dev with the 'handle' value is superfluous
so lets not do it.

Acked-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -623,7 +623,6 @@ static int dispatch_rw_block_io(struct x
 		goto fail_response;
 	}
 
-	preq.dev           = req->u.rw.handle;
 	preq.sector_number = req->u.rw.sector_number;
 	preq.nr_sects      = 0;
 


