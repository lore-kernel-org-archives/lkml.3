Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3HZGy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 02:54:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:8038 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3HZGyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 02:54:25 -0400
Message-ID: <521AFB77.9080401@huawei.com>
Date: Mon, 26 Aug 2013 14:53:43 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dougthompson@xmission.com>
CC: <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, <mchehab@redhat.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] edac: cell_edac: fix missing of_node_put
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


decrease device_node refcount np after task completion

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/edac/cell_edac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index c2eaf33..493dc30 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -162,6 +162,7 @@ static void cell_edac_init_csrows(struct mem_ctl_info *mci)
 			csrow->first_page, nr_pages);
 		break;
 	}
+	of_node_put(np);
 }

 static int cell_edac_probe(struct platform_device *pdev)
-- 
1.7.1

