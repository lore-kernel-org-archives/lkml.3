Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaINVxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 17:53:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52902 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaINVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 17:53:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: qla_mr.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 23:54:56 +0200
Message-Id: <1410731696-18247-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla2xxx/qla_mr.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 4775baa..23bc7e2 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1868,21 +1868,21 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			phost_info = &preg_hsi->hsi;
 			memset(preg_hsi, 0, sizeof(struct register_host_info));
 			phost_info->os_type = OS_TYPE_LINUX;
-			strncpy(phost_info->sysname,
+			strlcpy(phost_info->sysname,
 			    p_sysid->sysname, SYSNAME_LENGTH);
-			strncpy(phost_info->nodename,
+			strlcpy(phost_info->nodename,
 			    p_sysid->nodename, NODENAME_LENGTH);
 			if (!strcmp(phost_info->nodename, "(none)"))
 				ha->mr.host_info_resend = true;
-			strncpy(phost_info->release,
+			strlcpy(phost_info->release,
 			    p_sysid->release, RELEASE_LENGTH);
-			strncpy(phost_info->version,
+			strlcpy(phost_info->version,
 			    p_sysid->version, VERSION_LENGTH);
-			strncpy(phost_info->machine,
+			strlcpy(phost_info->machine,
 			    p_sysid->machine, MACHINE_LENGTH);
-			strncpy(phost_info->domainname,
+			strlcpy(phost_info->domainname,
 			    p_sysid->domainname, DOMNAME_LENGTH);
-			strncpy(phost_info->hostdriver,
+			strlcpy(phost_info->hostdriver,
 			    QLA2XXX_VERSION, VERSION_LENGTH);
 			do_gettimeofday(&tv);
 			preg_hsi->utc = (uint64_t)tv.tv_sec;
-- 
1.7.10.4

