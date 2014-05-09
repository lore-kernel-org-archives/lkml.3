Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaEIHq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:46:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23887 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEIHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:46:27 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-de-536c87d29133
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, jkosina@suse.cz,
        labbe.montjoie@gmail.com, a.kesavan@samsung.com,
        sreekumar.c@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/5] devfreq: Fix devfreq_remove_device() to improve the
 sequence of resource free
Date: Fri, 09 May 2014 16:43:07 +0900
Message-id: <1399621391-27228-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
References: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkQPdSe06wwcJuKYvHaxYzWVz/8pzV
	YvecxSwWZ5vesFusX7CQzeLyrjlsFp97jzBa3G5cwWbx5sdZJovHK96yWxx8uIDZgdtj56y7
	7B6L97xk8ujbsorR48yCI+wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2Nv93yWgp3iFZt+
	LGVpYDwh1MXIySEhYCIxf8tmRghbTOLCvfVsXYxcHEICSxklLj9ZwQZTdKbxLDtEYhGjxO/F
	WxghnCYmifPHt4G1swloSex/cQOsQ0TAXGLX0p9go5gFXjBKdGzcxAySEBZIk3i4pxXMZhFQ
	lehedIcFxOYVcJVYc/QI1Do5iQ97HrGD2JwCbhLr2yaA1QsB1Uxe1gVVc4hd4ugqF4g5AhLf
	Jh8CmsMBFJeV2HSAGaJEUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQI
	jI3T/55N2MF474D1IcZkoHETmaVEk/OBsZVXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxd9a0C86bxzHVaUDFdrnXWrtoQ+QtXq2YG2G50yX7w
	pUY9W3jnA52dloJmaUyJ1rf2P6q02pZ5SeH3rWvM6ktuhaxQFuyN65U2cY9jWHvKX/rPS5NZ
	z7h1T9+X4RVxfNaeH2W2pPVnk53sUQOp/ey8rlfKNrt1CEzbVh3PvCa4er/yiYJWMyWW4oxE
	Qy3mouJEAIFOaE6jAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jAV2h9pxgg99LJC0er1nMZHH9y3NW
	i91zFrNYnG16w26xfsFCNovLu+awWXzuPcJocbtxBZvFmx9nmSwer3jLbnHw4QJmB26PnbPu
	snss3vOSyaNvyypGjzMLjrB7HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZe7vnsxTsFK/Y9GMpSwPjCaEuRk4OCQETiTONZ9khbDGJC/fWs3UxcnEI
	CSxilPi9eAsjhNPEJHH++DZGkCo2AS2J/S9usIHYIgLmEruW/gTrYBZ4wSjRsXETM0hCWCBN
	4uGeVjCbRUBVonvRHRYQm1fAVWLN0SNsEOvkJD7seQS2mlPATWJ92wSweiGgmsnLutgmMPIu
	YGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREce8+kdjCubLA4xCjAwajEw/tiSnawEGti
	WXFl7iFGCQ5mJRFeqfScYCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB6aFvJJ4Q2MTMyNL
	I3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgVJao+1fYdDcrJ0U+oDfRxOH4
	u7TN53ijHDrbwvlNzXm6dU6qZDIYtrzmmLdjSYLJlOam1BWr1Y247PcfVmm+61MecsTpu2ey
	/M10jvoMN35vmUVblgleLpScscS49XhN4Jd6lwNpHHM6zu9pbzI03nJ2C/+zApnMS5Fv6sVY
	fxWnXua58ViJpTgj0VCLuag4EQA0WyCaAQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modify devfreq_remove_device() to improve the sequence of resource
free. If executing existing devfreq_remove_device(), this function always
executes _remove_devfreq() twice. In result, second _remove_devfreq() always
return error value. So, This patch resolves complicated function sequence
as following:

[Flow sequence before modification]
devfreq_remove_device()
   _remove_devfreq(devfreq, false)
      kfree(devfreq);  /* Free devfreq */
      if (!skip ...) { /* skip is false */
         device_unregister(&devfreq->dev)
         put_device(&devfreq->dev);
            ...
            dev->release()
               devfreq_dev_release()
                  _remove_devfreq(devfreq, true) <- Recall to free devfreq
                  /*
		   * Always return error without freeing resource because
		   * already _remove_devfreq() frees the memory of devfreq.
		   */
   }

[Flow sequence after modification]
devfreq_remove_device
   device_unregister(&devfreq->dev)
   put_device(&devfreq->dev);
      ..
      dev->release()
         devfreq_dev_release()
            _remove_devfreq()
               kfree(devfreq); /* Free devfreq */

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index d32c8b6..e960eb0 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -437,7 +437,7 @@ update:
  * @devfreq:	the devfreq struct
  * @skip:	skip calling device_unregister().
  */
-static void _remove_devfreq(struct devfreq *devfreq, bool skip)
+static void _remove_devfreq(struct devfreq *devfreq)
 {
 	mutex_lock(&devfreq_list_lock);
 	if (IS_ERR(find_device_devfreq(devfreq->dev.parent))) {
@@ -462,11 +462,6 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
 	if (devfreq->profile->exit)
 		devfreq->profile->exit(devfreq->dev.parent);
 
-	if (!skip && get_device(&devfreq->dev)) {
-		device_unregister(&devfreq->dev);
-		put_device(&devfreq->dev);
-	}
-
 	mutex_destroy(&devfreq->lock);
 	kfree(devfreq);
 }
@@ -476,14 +471,12 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
  * @dev:	the devfreq device
  *
  * This calls _remove_devfreq() if _remove_devfreq() is not called.
- * Note that devfreq_dev_release() could be called by _remove_devfreq() as
- * well as by others unregistering the device.
  */
 static void devfreq_dev_release(struct device *dev)
 {
 	struct devfreq *devfreq = to_devfreq(dev);
 
-	_remove_devfreq(devfreq, true);
+	_remove_devfreq(devfreq);
 }
 
 static int devfreq_qos_sanity_check(struct device *dev,
@@ -659,7 +652,8 @@ int devfreq_remove_device(struct devfreq *devfreq)
 	if (!devfreq)
 		return -EINVAL;
 
-	_remove_devfreq(devfreq, false);
+	device_unregister(&devfreq->dev);
+	put_device(&devfreq->dev);
 
 	return 0;
 }
-- 
1.8.0

