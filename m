Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3DOHo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:44:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41795 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3DOHo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:44:26 -0400
Date: Mon, 15 Apr 2013 10:44:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch] mwave: info leak in mwave_ioctl()
Message-ID: <20130415074404.GA20993@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains that on 64 bit systems, there is a hole in the
MW_ABILITIES struct between ->component_count and ->component_list[].
It leaks stack information from the mwave_ioctl() function.

I've added a memset() to initialize the struct to zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index c689697..04e6d6a 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -479,6 +479,7 @@ int tp3780I_QueryAbilities(THINKPAD_BD_DATA * pBDData, MW_ABILITIES * pAbilities
 	PRINTK_2(TRACE_TP3780I,
 		"tp3780i::tp3780I_QueryAbilities entry pBDData %p\n", pBDData);
 
+	memset(pAbilities, 0, sizeof(*pAbilities));
 	/* fill out standard constant fields */
 	pAbilities->instr_per_sec = pBDData->rDspSettings.uIps;
 	pAbilities->data_size = pBDData->rDspSettings.uDStoreSize;
