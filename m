Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3FAJwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:52:30 -0400
Received: from www17.your-server.de ([213.133.104.17]:60182 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267Ab3FAJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:52:23 -0400
Message-ID: <1370080336.29224.23.camel@localhost.localdomain>
Subject: [PATCH] s390/dasd: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:52:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2968,7 +2968,7 @@ static int prepare_itcw(struct itcw *itc
 
 	dcw = itcw_add_dcw(itcw, pfx_cmd, 0,
 		     &pfxdata, sizeof(pfxdata), total_data_size);
-	return IS_ERR(dcw) ? PTR_ERR(dcw) : 0;
+	return PTR_RET(dcw);
 }
 
 static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(


