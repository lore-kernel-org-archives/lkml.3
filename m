Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaHHLu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:50:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48349 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbaHHLuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:50:23 -0400
X-AuditID: 85900ec0-d272ab9000001514-50-53e4b97a84b2
Subject: [RFC PATCH 05/10] scsi/trace: Use macros for getting driver byte,
 host byte, msg byte, and status byte
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Date: Fri, 08 Aug 2014 11:50:17 +0000
Message-ID: <20140808115017.6768.74578.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For getting driver byte, host byte, msg byte, and status byte, macros are
implemented in scsi/scsi.h, so we use it.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 include/trace/events/scsi.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index db6c935..8aecdc2 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -328,10 +328,10 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
-		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
-		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
-		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
-		  show_statusbyte_name(__entry->result & 0xff))
+		  show_driverbyte_name(driver_byte(__entry->result)),
+		  show_hostbyte_name(host_byte(__entry->result)),
+		  show_msgbyte_name(msg_byte(__entry->result)),
+		  show_statusbyte_name(status_byte(__entry->result)))
 );
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,

