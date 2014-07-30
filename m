Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaG3GZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:25:56 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:48179 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbaG3GZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:25:54 -0400
From: Nilesh Javali <nilesh.javali@qlogic.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Vikas Chaudhary" <vikas.chaudhary@qlogic.com>,
        Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: qla4xxx: ql4_os.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
Thread-Topic: [PATCH] scsi: qla4xxx: ql4_os.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
Thread-Index: AQHPqOCda15Wjn7IO0ixf7tMeEKI25u4LAlQ
Date: Wed, 30 Jul 2014 06:25:44 +0000
Message-ID: <058691E078642A44B7C96BB0B1DB4F2446C29A10@avmb2.qlogic.org>
References: <1406386172-4142-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1406386172-4142-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7514 signatures=670489
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407300083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Nilesh Javali <nilesh.javali@qlogic.com>


-----Original Message-----
From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se] 
Sent: Saturday, July 26, 2014 8:20 PM
To: Vikas Chaudhary; Dept-Eng iSCSI Driver
Cc: Rickard Strandqvist; James E.J. Bottomley; linux-scsi; linux-kernel
Subject: [PATCH] scsi: qla4xxx: ql4_os.c: Cleaning up missing null-terminate in conjunction with strncpy

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla4xxx/ql4_os.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c index 3202063..a07c53e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -756,9 +756,9 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 			continue;
 
 		chap_rec->chap_tbl_idx = i;
-		strncpy(chap_rec->username, chap_table->name,
+		strlcpy(chap_rec->username, chap_table->name,
 			ISCSI_CHAP_AUTH_NAME_MAX_LEN);
-		strncpy(chap_rec->password, chap_table->secret,
+		strlcpy(chap_rec->password, chap_table->secret,
 			QL4_CHAP_MAX_SECRET_LEN);
 		chap_rec->password_length = chap_table->secret_len;
 
@@ -6027,8 +6027,8 @@ static int qla4xxx_get_bidi_chap(struct scsi_qla_host *ha, char *username,
 		if (!(chap_table->flags & BIT_6)) /* Not BIDI */
 			continue;
 
-		strncpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
-		strncpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+		strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+		strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
 		ret = 0;
 		break;
 	}
@@ -6258,8 +6258,8 @@ static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 
 	tddb->tpgt = sess->tpgt;
 	tddb->port = conn->persistent_port;
-	strncpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
-	strncpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
+	strlcpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
+	strlcpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
 }
 
 static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry, @@ -7764,7 +7764,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		goto exit_ddb_logout;
 	}
 
-	strncpy(flash_tddb->iscsi_name, fnode_sess->targetname,
+	strlcpy(flash_tddb->iscsi_name, fnode_sess->targetname,
 		ISCSI_NAME_SIZE);
 
 	if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
--
1.7.10.4

