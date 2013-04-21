Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3DURBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:01:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45370 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3DURBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:01:15 -0400
Date: Sun, 21 Apr 2013 20:01:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, walter harms <wharms@bfs.de>
Subject: [patch v2] gru: info leak in gru_get_config_info()
Message-ID: <20130421170107.GA16118@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421131902.GT3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "info.fill" array isn't initialized so it can leak uninitialized
stack information to user space.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: style changes

diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 44d273c..0535d1e 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -172,6 +172,7 @@ static long gru_get_config_info(unsigned long arg)
 		nodesperblade = 2;
 	else
 		nodesperblade = 1;
+	memset(&info, 0, sizeof(info));
 	info.cpus = num_online_cpus();
 	info.nodes = num_online_nodes();
 	info.blades = info.nodes / nodesperblade;
