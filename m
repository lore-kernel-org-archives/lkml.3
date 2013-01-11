Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3AKGsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:48:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34228 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3AKGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:48:05 -0500
Date: Fri, 11 Jan 2013 09:48:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Jones <pjones@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] ibft: add a missing break statement
Message-ID: <20130111064807.GA13207@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code works the same with or without the break.  It just looks a bit
cleaner to not fall through.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 3ee852c..c4b187c 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -503,6 +503,7 @@ static umode_t __init ibft_check_tgt_for(void *data, int type)
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 	case ISCSI_BOOT_TGT_CHAP_TYPE:
 		rc = S_IRUGO;
+		break;
 	case ISCSI_BOOT_TGT_NAME:
 		if (tgt->tgt_name_len)
 			rc = S_IRUGO;
