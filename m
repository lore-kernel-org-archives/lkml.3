Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3CZXph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:45:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3CZWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>,
        Dmitry Kravkov <dmitry@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/98] bnx2x: add missing napi deletion in error path
Date: Tue, 26 Mar 2013 15:42:07 -0700
Message-Id: <20130326224244.365678981@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 722c6f585088a2c392b4c5d01b87a584bb8fb73f ]

If the hardware initialization fails in bnx2x_nic_load() after adding
napi objects, they would not be deleted. A subsequent attempt to unload
the bnx2x module detects a corruption in the napi list.

Add the missing napi deletion to the error path.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2523,6 +2523,7 @@ load_error2:
 	bp->port.pmf = 0;
 load_error1:
 	bnx2x_napi_disable(bp);
+	bnx2x_del_all_napi(bp);
 	/* clear pf_load status, as it was already set */
 	bnx2x_clear_pf_load(bp);
 load_error0:


