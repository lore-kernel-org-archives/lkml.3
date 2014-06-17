Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaFQO05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:26:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47098 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaFQO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:26:55 -0400
Message-ID: <53A05027.5020407@oracle.com>
Date: Tue, 17 Jun 2014 22:26:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: Christoph Lameter <cl@gentwo.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/24] sample/kobject: update kset-example code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>
Subject: sample/kobject: update kset-example code

Check and return the error ptr if call kset_create_and_add() failed

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 samples/kobject/kset-example.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index ab5e447..c2911d9 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -238,8 +238,8 @@ static int __init example_init(void)
 	 * located under /sys/kernel/
 	 */
 	example_kset = kset_create_and_add("kset_example", NULL, kernel_kobj);
-	if (!example_kset)
-		return -ENOMEM;
+	if (IS_ERR(example_kset))
+		return PTR_ERR(example_kset);
 
 	/*
 	 * Create three objects and register them with our kset
-- 
1.8.3.2
