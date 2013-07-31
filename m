Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3GaN0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47141 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759607Ab3GaN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andi Kleen" <andi@firstfloor.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.643209679@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [29/84] [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1788,7 +1788,7 @@ static void bnx2fc_parse_fcp_rsp(struct
 			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
 		}
 
-		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
+		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (fcp_sns_len)
 			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
 

