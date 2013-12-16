Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3LPPLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:11:44 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:54778 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3LPPK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:56 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 1/5] VFS: Convert drop_caches to accept string
Date: Mon, 16 Dec 2013 07:00:05 -0800
Message-Id: <95d2d9c42afac287d42eecb160569eac4c59d90a.1387205337.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpMVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNSQzPj
	o*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQzLjU6NUFLVU
	tAPyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQCk#OjckMiskMjUkKTk3JDI1JDM#Oj8#KUFKSV
	VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JDM#Oj8#KUFJVUtAMiskLzQ*OiIkODUvJEskSktLQU
	tVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskSiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJE
	okMzQuKSQ4NS8kSyRKS0tBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtAKC45JD5BSlVOTk
	A9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SUtNS05PTUxLVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlKS0s3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 kernel/sysctl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..2f2d8ab 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1255,12 +1255,10 @@ static struct ctl_table vm_table[] = {
 	},
 	{
 		.procname	= "drop_caches",
-		.data		= &sysctl_drop_caches,
-		.maxlen		= sizeof(int),
+		.data		= sysctl_drop_caches,
+		.maxlen		= PATH_MAX,
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
-		.extra1		= &one,
-		.extra2		= &three,
 	},
 #ifdef CONFIG_COMPACTION
 	{
-- 
1.7.9.5

