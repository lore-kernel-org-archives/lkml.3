Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaACU7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:59:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31454 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaACU7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:59:37 -0500
Date: Fri, 3 Jan 2014 23:59:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Teodora Baluta <teobaluta@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] staging: vt6655: check too restrictive (off by one)
Message-ID: <20140103205909.GA9698@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

key_len == MAX_KEY_LEN is valid but we return an error.

Introduced-by: 6b7200fe0a59 ('Staging: vt6655: memory corruption in check in wpa_set_wpadev()')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index ee83704e4401..d43efb85f4d3 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -202,8 +202,8 @@ int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
 	int uu, ii;
 
 	if (param->u.wpa_key.alg_name > WPA_ALG_CCMP ||
-	    param->u.wpa_key.key_len >= MAX_KEY_LEN ||
-	    param->u.wpa_key.seq_len >= MAX_KEY_LEN)
+	    param->u.wpa_key.key_len > MAX_KEY_LEN ||
+	    param->u.wpa_key.seq_len > MAX_KEY_LEN)
 		return -EINVAL;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d \n", param->u.wpa_key.alg_name);
