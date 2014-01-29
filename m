Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaA2QdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:33:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaA2Qc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:32:59 -0500
Date: Wed, 29 Jan 2014 11:22:11 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: parav.pandit@emulex.com, roland@purestorage.com
Subject: ocrdma: missing break in switch statement.
Message-ID: <20140129162211.GA16149@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	parav.pandit@emulex.com, roland@purestorage.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been going through the 'missing break' warnings in coverity, and there's a bunch
in infiniband. A lot look intentional, but this one can't be right.
We set a variable, and then immediately overwrite it.

instead of adding break spaghetti, just return the correct value.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 1664d648cbfc..b45b7f8d9103 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -234,9 +234,9 @@ static int ocrdma_get_mbx_errno(u32 status)
 	case OCRDMA_MBX_STATUS_FAILED:
 		switch (add_status) {
 		case OCRDMA_MBX_ADDI_STATUS_INSUFFICIENT_RESOURCES:
-			err_num = -EAGAIN;
-			break;
+			return -EAGAIN;
 		}
+
 	default:
 		err_num = -EFAULT;
 	}
