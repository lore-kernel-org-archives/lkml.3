Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3EaIzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:55:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12026 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3EaIyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:54:40 -0400
X-AuditID: cbfee68e-b7f276d000002279-3b-51a8654e78b1
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com
Subject: [RFC][PATCH 2/2] drm/prime: find gem object from the reimported dma-buf
Date: Fri, 31 May 2013 17:54:47 +0900
Message-id: <1369990487-23510-3-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkQNcvdUWgwYePmha9504yWSx8eJfZ
	4srX92wWk+5PYLE42/SG3eLLlYdMFpd3zWGz6NmwldXi1N3P7BYzJr9kc+Dy2PttAYvHnWt7
	2Dy2f3vA6nG/+ziTx+1/j5k9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2Pb3NuMBe+lK448
	PcfSwNgn3sXIySEhYCLxq+8cI4QtJnHh3nq2LkYuDiGBpYwS1y6eZoUputY6nxkiMZ1RYsGh
	SywQTjOTxJz9LWBVbAI6EvuX/AazRQR6GSXW3GMCKWIWaGaUeLTsD5DDwSEsECAxc2U5SA2L
	gKpE74Y1TCA2r4CbxJbNt6HOUJBYcO8tG4jNKeAusb7vMguILQRUc2/efXaQmRICx9glDix5
	zQ4xSEDi2+RDLCDzJQRkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al
	6yXn525iBMbG6X/P+nYw3jxgfYgxGWjcRGYp0eR8YGzllcQbGpsZWZiamBobmVuakSasJM6r
	1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx54wwr9HNo9m8f7UiYv+bfsmzzl+v89g6
	0OoL69079ou0QsslWERzN9xS5uQRPtU1hT1hzUOuxP6+me7VKy3+RrJq2mnOdQyZfIBFW8F6
	r6LQpGUzJd3P1i+wXZSfriy2b9l6F3cG+dz0Wb2zv8kGsrQr/hdZbiCQGcq2u+Zy7g+TY/ti
	HyqxFGckGmoxFxUnAgABD31vowIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t9jQV2/1BWBBteeKVr0njvJZLHw4V1m
	iytf37NZTLo/gcXibNMbdosvVx4yWVzeNYfNomfDVlaLU3c/s1vMmPySzYHLY++3BSwed67t
	YfPY/u0Bq8f97uNMHrf/PWb26NuyitHj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZ2+beZix4L11x5Ok5lgbGPvEuRk4OCQETiWut85khbDGJC/fWs3UxcnEI
	CUxnlFhw6BILhNPMJDFnfwsrSBWbgI7E/iW/wWwRgV5GiTX3mECKmAWaGSUeLfsD5HBwCAsE
	SMxcWQ5SwyKgKtG7YQ0TiM0r4CaxZfNtRohtChIL7r1lA7E5Bdwl1vddZgGxhYBq7s27zz6B
	kXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODIeya9g3FVg8UhRgEORiUe3oMpywOF
	WBPLiitzDzFKcDArifDqBq8IFOJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YFLIK4k3NDYx
	M7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG/pNZOddvrxS0PrLi+k31
	y7J5HZlT1wZqXhL+xtmfsn97o4rkc0mVN1snsCyf/dT0zKZtAgF305TLN7dbLXnlMuVec9n7
	BW7hvAtibGKcTM5VnOfjZLh7UeGmyTYFwdCIJXucl9/qyz/WdNXo+f0XRm/M53ouUqy893qJ
	X6HtdMajc8VfrK0JUmIpzkg01GIuKk4EAOntuXQAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimported dma-buf can reuse same gem object only when prime import
is done with same drm open context. So prime import is done with
other drm open context, gem object is newly created and mapped even
there is already mapped gem object. To avoid recreating gem object,
importer private data can be used at reimport time if it is assigned
with drm gem object at first import.
This can also remove remapping dma address for the hardware having
its own iommu.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/gpu/drm/drm_prime.c                |   19 ++++++++++++++-----
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/udl/udl_gem.c              |    1 +
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index dcde352..78a3c7d 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -294,6 +294,7 @@ struct drm_gem_object *drm_gem_prime_import(struct drm_device *dev,
 	}
 
 	obj->import_attach = attach;
+	attach->importer_priv = obj;
 
 	return obj;
 
@@ -312,6 +313,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 {
 	struct dma_buf *dma_buf;
 	struct drm_gem_object *obj;
+	struct dma_buf_attachment *attach;
 	int ret;
 
 	dma_buf = dma_buf_get(prime_fd);
@@ -327,11 +329,18 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 		goto out_put;
 	}
 
-	/* never seen this one, need to import */
-	obj = dev->driver->gem_prime_import(dev, dma_buf);
-	if (IS_ERR(obj)) {
-		ret = PTR_ERR(obj);
-		goto out_put;
+	attach = dma_buf_get_attachment(dma_buf, dev->dev);
+	if (IS_ERR(attach)) {
+		/* never seen this one, need to import */
+		obj = dev->driver->gem_prime_import(dev, dma_buf);
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
+			goto out_put;
+		}
+	} else {
+		/* found attachment to same device */
+		obj = attach->importer_priv;
+		drm_gem_object_reference(obj);
 	}
 
 	ret = drm_gem_handle_create(file_priv, obj, handle);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index ff7f2a8..268da36 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -285,6 +285,7 @@ struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
 	exynos_gem_obj->buffer = buffer;
 	buffer->sgt = sgt;
 	exynos_gem_obj->base.import_attach = attach;
+	attach->importer_priv = &exynos_gem_obj->base;
 
 	DRM_DEBUG_PRIME("dma_addr = 0x%x, size = 0x%lx\n", buffer->dma_addr,
 								buffer->size);
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index dc53a52..75ef28c 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -297,6 +297,7 @@ struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
 
 	i915_gem_object_init(obj, &i915_gem_object_dmabuf_ops);
 	obj->base.import_attach = attach;
+	attach->importer_priv = &obj->base;
 
 	return &obj->base;
 
diff --git a/drivers/gpu/drm/udl/udl_gem.c b/drivers/gpu/drm/udl/udl_gem.c
index ef034fa..0652db1 100644
--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -317,6 +317,7 @@ struct drm_gem_object *udl_gem_prime_import(struct drm_device *dev,
 	}
 
 	uobj->base.import_attach = attach;
+	attach->importer_priv = &uobj->base;
 
 	return &uobj->base;
 
-- 
1.7.4.1

