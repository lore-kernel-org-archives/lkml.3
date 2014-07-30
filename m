Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaG3Ub2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:31:28 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60308 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaG3Ub0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:31:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390: net: claw.c:  Cleaning up possible error if incorrect in parameter
Date: Wed, 30 Jul 2014 22:32:52 +0200
Message-Id: <1406752372-19743-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Possible error if incorrect in parameter, count = 0.
And clarified what the code actually does significantly.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/net/claw.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index d837c3c..8d5b7b6 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -3070,10 +3070,10 @@ claw_hname_write(struct device *dev, struct device_attribute *attr,
 	p_env = priv->p_env;
 	if (count > MAX_NAME_LEN+1)
 		return -EINVAL;
-	memset(p_env->host_name, 0x20, MAX_NAME_LEN);
-	strncpy(p_env->host_name,buf, count);
-	p_env->host_name[count-1] = 0x20;  /* clear extra 0x0a */
-	p_env->host_name[MAX_NAME_LEN] = 0x00;
+	strlcpy(p_env->host_name, buf,
+			sizeof(p_env->host_name));
+	strlcat(p_env->host_name, "        ",
+			sizeof(p_env->host_name));
 	CLAW_DBF_TEXT(2, setup, "HstnSet");
 	CLAW_DBF_TEXT_(2, setup, "%s", p_env->host_name);
 
@@ -3108,10 +3108,10 @@ claw_adname_write(struct device *dev, struct device_attribute *attr,
 	p_env = priv->p_env;
 	if (count > MAX_NAME_LEN+1)
 		return -EINVAL;
-	memset(p_env->adapter_name, 0x20, MAX_NAME_LEN);
-	strncpy(p_env->adapter_name,buf, count);
-	p_env->adapter_name[count-1] = 0x20; /* clear extra 0x0a */
-	p_env->adapter_name[MAX_NAME_LEN] = 0x00;
+	strlcpy(p_env->adapter_name, buf,
+			sizeof(p_env->adapter_name));
+	strlcat(p_env->adapter_name, "        ",
+			sizeof(p_env->adapter_name));
 	CLAW_DBF_TEXT(2, setup, "AdnSet");
 	CLAW_DBF_TEXT_(2, setup, "%s", p_env->adapter_name);
 
@@ -3147,10 +3147,10 @@ claw_apname_write(struct device *dev, struct device_attribute *attr,
 	p_env = priv->p_env;
 	if (count > MAX_NAME_LEN+1)
 		return -EINVAL;
-	memset(p_env->api_type, 0x20, MAX_NAME_LEN);
-	strncpy(p_env->api_type,buf, count);
-	p_env->api_type[count-1] = 0x20;  /* we get a loose 0x0a */
-	p_env->api_type[MAX_NAME_LEN] = 0x00;
+	strlcpy(p_env->api_type, buf,
+			sizeof(p_env->api_type));
+	strlcat(p_env->api_type, "        ",
+			sizeof(p_env->api_type));
 	if(strncmp(p_env->api_type,WS_APPL_NAME_PACKED,6) == 0) {
 		p_env->read_size=DEF_PACK_BUFSIZE;
 		p_env->write_size=DEF_PACK_BUFSIZE;
-- 
1.7.10.4

