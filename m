Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3EaIzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:55:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23259 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3EaIyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:54:40 -0400
X-AuditID: cbfee68e-b7f276d000002279-30-51a8654ee6ce
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com
Subject: [RFC][PATCH 1/2] dma-buf: add importer private data to attachment
Date: Fri, 31 May 2013 17:54:46 +0900
Message-id: <1369990487-23510-2-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSoOuXuiLQ4PoGJYvecyeZLBY+vMts
	ceXrezaLSfcnsFicbXrDbvHlykMmi8u75rBZ9GzYympx6u5ndosZk1+yOXB57P22gMXjzrU9
	bB7bvz1g9bjffZzJ4/a/x8wefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlfHlr0bBMrGKNWeu
	MzUwLhHqYuTkkBAwkbjyu4EZwhaTuHBvPRuILSSwlFHi567KLkYOsJqnMw27GLmAwtMZJe68
	P80K4TQzSczZ38IK0sAmoCOxf8lvMFtEoJdRYs09JpAiZoFmRolHy/4wgSSEBbwkNsw9AWaz
	CKhK/L6+hAXE5hVwk1g2+yUjxBUKEgvuvQW7glPAXWJ932UWiIvcJO7Nu88OUXOMXeLO7QyI
	OQIS3yYfYoG4VFZi0wGoZyQlDq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxN
	jMCoOP3vWd8OxpsHrA8xJgONm8gsJZqcD4yqvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwNsSsm9XNf776eZOzxDm+/26/mZdPfbKkNmzb9v7m
	l6cv77l8j/WoItcBA8mqJ/miPMGlE1dbeExmiXe4fyNHrvz3QsnorWd8P59l0FqxX3jHJl31
	6z5mey81bI2e2bIkyPXrR56N18uFhEol2YIlTPo0p8adSp+xJ0NnstIEpZTsxPm+mzcfUWIp
	zkg01GIuKk4EAIuQ6ZSgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQV2/1BWBBh/3SFn0njvJZLHw4V1m
	iytf37NZTLo/gcXibNMbdosvVx4yWVzeNYfNomfDVlaLU3c/s1vMmPySzYHLY++3BSwed67t
	YfPY/u0Bq8f97uNMHrf/PWb26NuyitHj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZX/5qFCwTq1hz5jpTA+MSoS5GDg4JAROJpzMNuxg5gUwxiQv31rN1MXJx
	CAlMZ5S48/40K4TTzCQxZ38LK0gVm4COxP4lv8FsEYFeRok195hAipgFmhklHi37wwSSEBbw
	ktgw9wSYzSKgKvH7+hIWEJtXwE1i2eyXjBDrFCQW3HvLBmJzCrhLrO+7DFYjBFRzb9599gmM
	vAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfdM+kdjKsaLA4xCnAwKvHwHkxZHijE
	mlhWXJl7iFGCg1lJhFc3eEWgEG9KYmVValF+fFFpTmrxIcZkoKsmMkuJJucDU0JeSbyhsYmZ
	kaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDOi7vIc1LuoLelkVqF8Adj
	/Zu5fZt839Tu5N310TJRa/s04Ts/bvZPnn5T2zFVZseinJOcIQceNk7TkZXxPPklt3DelAlz
	am68+xHyL1T/qEV6UdVuSTvuJZf4DErXd8sYVV3da98t3b3iZ8CpHbvSXoTJf9scsN5w+t1z
	d14dyl+x+eavC0tblFiKMxINtZiLihMBcBWjZ/8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-buf attachment has only exporter private data, but importer private data
can be useful for importer especially to re-import the same dma-buf.
To use importer private data in attachment of the device, the function to
search attachment in the attachment list of dma-buf is also added.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/base/dma-buf.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/dma-buf.h |    4 ++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 08fe897..a1eaaf2 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -259,6 +259,37 @@ err_attach:
 EXPORT_SYMBOL_GPL(dma_buf_attach);
 
 /**
+ * dma_buf_get_attachment - Get attachment with the device from dma_buf's
+ * attachments list
+ * @dmabuf:	[in]	buffer to find device from.
+ * @dev:	[in]	device to be found.
+ *
+ * Returns struct dma_buf_attachment * attaching the device; may return
+ * negative error codes.
+ *
+ */
+struct dma_buf_attachment *dma_buf_get_attachment(struct dma_buf *dmabuf,
+						  struct device *dev)
+{
+	struct dma_buf_attachment *attach;
+
+	if (WARN_ON(!dmabuf || !dev))
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&dmabuf->lock);
+	list_for_each_entry(attach, &dmabuf->attachments, node) {
+		if (attach->dev == dev) {
+			mutex_unlock(&dmabuf->lock);
+			return attach;
+		}
+	}
+	mutex_unlock(&dmabuf->lock);
+
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(dma_buf_get_attachment);
+
+/**
  * dma_buf_detach - Remove the given attachment from dmabuf's attachments list;
  * optionally calls detach() of dma_buf_ops for device-specific detach
  * @dmabuf:	[in]	buffer to detach from.
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index dfac5ed..09cff0f 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -136,6 +136,7 @@ struct dma_buf {
  * @dev: device attached to the buffer.
  * @node: list of dma_buf_attachment.
  * @priv: exporter specific attachment data.
+ * @importer_priv: importer specific attachment data.
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -146,6 +147,7 @@ struct dma_buf_attachment {
 	struct device *dev;
 	struct list_head node;
 	void *priv;
+	void *importer_priv;
 };
 
 /**
@@ -164,6 +166,8 @@ static inline void get_dma_buf(struct dma_buf *dmabuf)
 
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 							struct device *dev);
+struct dma_buf_attachment *dma_buf_get_attachment(struct dma_buf *dmabuf,
+							struct device *dev);
 void dma_buf_detach(struct dma_buf *dmabuf,
 				struct dma_buf_attachment *dmabuf_attach);
 
-- 
1.7.4.1

