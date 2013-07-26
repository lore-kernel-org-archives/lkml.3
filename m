Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab3GZVEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:04:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab3GZU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 30/45] SCSI: Fix incorrect memset in bnx2fc_parse_fcp_rsp
Date: Fri, 26 Jul 2013 13:57:50 -0700
Message-Id: <20130726205658.235055081@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit 16da05b1158d1bcb31656e636a8736a663b1cf1f upstream.

gcc 4.8 warns because the memset only clears sizeof(char *) bytes, not
the whole buffer. Use the correct buffer size and clear the whole sense
buffer.

/backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c: In
function 'bnx2fc_parse_fcp_rsp':
/backup/lsrc/git/linux-lto-2.6/drivers/scsi/bnx2fc/bnx2fc_io.c:1810:41:
warning: argument to 'sizeof' in 'memset' call is the same expression as
the destination; did you mean to provide an explicit length?
[-Wsizeof-pointer-memaccess]
   memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
                                         ^

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1618,7 +1618,7 @@ static void bnx2fc_parse_fcp_rsp(struct
 			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
 		}
 
-		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
+		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
 


