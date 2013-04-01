Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab3DAOAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 10:00:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43909 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3DAN5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:57:46 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-b7-515992590c69
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 02/11] USB: dwc3: Adjust runtime pm to allow autosuspend
Date: Mon, 01 Apr 2013 19:24:01 +0530
Message-id: <1364824448-14732-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkVjdyUmSgwb+l7BYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DKOLPvBVvBGp6Kx6u3MjcwTufqYuTkkBAwkTj1dh8ThC0mceHeerYuRi4O
	IYGljBJ/Xixggik6/mYdK0RiEaPEj0/7GSGcKUwSpyZ9YAGpYhPQlWh6uwsowcEhIhAnsXmC
	MEiYWaCLSWLpUXEQW1jAW2Lh/n6wchYBVYk7Z5tYQWxeAQ+JqRvvs0MsU5B4c/sZM4jNKeAp
	8WHrYrAjhIBq2q+eYIWoecQuceKnLcQcAYlvkw+xgKyVEJCV2HSAGaJEUuLgihssExiFFzAy
	rGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjKLT/57172C8e8D6EGMy0LiJzFKiyfnAKMwr
	iTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OClF1/
	+c0ML5uv8btRlNT97U38Obb6DOG/H/fNMA2OaFZvWT5lV53Hda3HOd4z6nKblSsmHODVSmdN
	Opf+IphTZovaLa4Fy2Z6cq22SlVckGFtcvf3zLfr1ObuZjjrslg7ySSn8f+ypOW8jLPVOs/u
	Nrh0ateL++/ixN2FOrx1m966b+sK8VNiKc5INNRiLipOBAAzrjlfuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG7EpMhAg8tzrSwO3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePMvhdsBWt4Kh6v3srcwDidq4uR
	k0NCwETi+Jt1rBC2mMSFe+vZuhi5OIQEFjFK/Pi0nxHCmcIkcWrSBxaQKjYBXYmmt7uAEhwc
	IgJxEpsnCIOEmQW6mCSWHhUHsYUFvCUW7u8HK2cRUJW4c7YJbAGvgIfE1I332SGWKUi8uf2M
	GcTmFPCU+LB1MROILQRU0371BOsERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj
	9JnUDsaVDRaHGAU4GJV4eCMuRAQKsSaWFVfmHmKU4GBWEuFdkRkZKMSbklhZlVqUH19UmpNa
	fIgxGeiqicxSosn5wASSVxJvaGxibmpsamliYWJmSZqwkjjvgVbrQCGB9MSS1OzU1ILUIpgt
	TBycUg2Msv+tNxtdzjx7eq/5mcXbpBUtkib0f/irtOtsc5CWa5r28zUcv4xWGQXNFbjwrrBb
	fM0hYdMzSupTXkU8O5fzxbnE6L2q0Mmdzdcm10xdqZ7G8eHVjj2OL6WET0g8P33pXPfCmdPO
	/f0U/EXw40smW96blxS0Gdo9lrDd+PQ1tPkjT6q+nJmTpxJLcUaioRZzUXEiAFOHOu0WAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code in the dwc3 probe effectively disables runtime pm
from ever working because it calls a get() that was never put() until
device removal.  Change the runtime pm code to match the standard
formula and allow runtime pm to function.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/dwc3/core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e2325ad..3a6993c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -491,6 +491,11 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 
+	/* Setting device state as 'suspended' initially,
+	 * to make sure we know device state prior to
+	 * pm_runtime_enable
+	 */
+	pm_runtime_set_suspended(dev);
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_forbid(dev);
@@ -566,6 +571,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err3;
 	}
 
+	pm_runtime_put_sync(dev);
 	pm_runtime_allow(dev);
 
 	return 0;
@@ -595,6 +601,7 @@ err1:
 
 err0:
 	dwc3_free_event_buffers(dwc);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }
@@ -606,7 +613,6 @@ static int dwc3_remove(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	dwc3_debugfs_exit(dwc);
-- 
1.7.6.5

