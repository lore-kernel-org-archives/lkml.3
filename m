Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaDYJIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:08:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48805 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaDYJIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:08:19 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-a1-535a2600028f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, cw00.choi@samsung.com,
        jkosina@suse.cz, labbe.montjoie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] devfreq: Fix devfreq_remove_device() to improve the
 sequence of resource free
Date: Fri, 25 Apr 2014 18:08:10 +0900
Message-id: <1398416894-6782-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
References: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSoMugFhVs8POzpcX1L89ZLXbPWcxi
	cbbpDbvF+gUL2Swu75rDZvG59wijxe3GFWwWb36cZbJ4vOItuwOnx85Zd9k9Fu95yeTRt2UV
	o8eZBUfYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfG3u75LAU7xSs2/VjK0sB4QqiLkZND
	QsBEYknvNRYIW0ziwr31bCC2kMBSRomf8yVhahYtOsXexcgFFF/EKHH2/EsmCKeJSeLxrlPM
	IFVsAloS+1/cAOsWETCX2LX0J5jNLLCcUWLr3DAQW1ggRWLttyesIDaLgKrEvqblTCA2r4CL
	xJIF65ghtslJfNjziB3E5hRwlWj/+ZYV4iIXicbHr8CukBDYxC6xdelNJohBAhLfJh8CeoED
	KCErsekA1BxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwCk7/ezZx
	B+P9A9aHGJOBxk1klhJNzgdGUV5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MIryytw8bxDw5v+97H/3Km+7aJTcD3jN2pQ7o2ql2+Vw5b+dNXMm
	ryyfE7NNgLny+JOLa4/ws/QVvvTY5Wzf5DMp9fKx+LgdlcdFQzpkdC0nMr4r6xJb43DQXuXc
	i6qNGe6PWNmNLu45FGgb01V55H/reZuuO48NZMO/BN0y0ZmTG39xiwmXtBJLcUaioRZzUXEi
	ACUdczOYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAV0Gtahgg3X/DCyuf3nOarF7zmIW
	i7NNb9gt1i9YyGZxedccNovPvUcYLW43rmCzePPjLJPF4xVv2R04PXbOusvusXjPSyaPvi2r
	GD3OLDjC7nH8xnYmj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAzlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYw
	Zuztns9SsFO8YtOPpSwNjCeEuhg5OSQETCQWLTrFDmGLSVy4t56ti5GLQ0hgEaPE2fMvmSCc
	JiaJx7tOMYNUsQloSex/cYMNxBYRMJfYtfQnmM0ssJxRYuvcMBBbWCBFYu23J6wgNouAqsS+
	puVMIDavgIvEkgXrmCG2yUl82PMIbDOngKtE+8+3YPVCQDWNj1+xT2DkXcDIsIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOMqeSe1gXNlgcYhRgINRiYf3g1pksBBrYllxZe4hRgkOZiUR
	3hkSUcFCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA9MAHkl8YbGJmZGlkbmhhZGxuakCSuJ
	8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLj2o+KWKO//l3UWTTCYlHXrfdKEv1dOrtdIfrU8
	p6r2fIO/vTBjs7OAhNMC9a7LNnvdo2J8Yo/f4glfU7R46pOW8HAGhq0pyWcZ3hgnKWhZbBPt
	6U7utJC1P2Qx+ffpNaXC2z+yRCZu3cpYELd/6v+zjTeWdX8oKuHSMRDxiZ6Y3PRvr0x5lRJL
	cUaioRZzUXEiAG2lGBX2AgAA
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

