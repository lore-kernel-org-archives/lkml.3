Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaLITa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:30:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20795 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaLITaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:30:22 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ce-54874dcb4aa2
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [RFC PATCH 1/2] iio: kfifo: Remove unused argument in
 iio_kfifo_allocate
Date: Tue, 09 Dec 2014 20:29:44 +0100
Message-id: <1418153385-18212-2-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418153385-18212-1-git-send-email-k.wrona@samsung.com>
References: <1418153385-18212-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7qnfdtDDFa+sbTYOGM9q8WDplVM
	FqeW7Wey2PX/DbPF2aY37Bbzjrxjsbi8aw6bxZ51W5gcODx2zrrL7vHhY5zHplWdbB59W1Yx
	enzeJBfAGsVlk5Kak1mWWqRvl8CVMW8LW8FLnoq9fb/ZGxifcHUxcnJICJhIHO08zQhhi0lc
	uLeeDcQWEljKKHHxsiKE3ccksXA6N4jNJqAu0bxjMXMXIxeHiEALo8SLn7tYQRxmgTWMEmfO
	TmAHqRIWCJY4sOgNUBUHB4uAqsSluyEgYV4BZ4mvq3vYQcISAgoScybZgIQ5BVwkNuxazgIS
	FgIqObU1cAIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIWH1dQfj0mNWhxgFOBiV
	eHh3KLaFCLEmlhVX5h5ilOBgVhLhXcvSHiLEm5JYWZValB9fVJqTWnyIkYmDU6qBMcGLzVI6
	88+/W+1rGfRte13sf/QYCUStXvhpwb2te5n2vTAITfjXdWVtZda7dJ6Hy9h9Q/NuqpwJ/f9q
	QfThlZPn/mLjcC9qbzr3rPl8q+npbxuys1fLL3qtfGq98F2lf5trd8wxO+Gie+Yt02Wzb39D
	Fj9N+6DT1u8QzXOb4Z2mk3h9f/WFYiWW4oxEQy3mouJEAJ+vSZ0JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

indio_dev was unused in function body plus some small style fix - add new
lines after "if(sth) return sth" and before the last return statement.

Change-Id: I9495c778dc7bc87cc4503e890397b576966c44fd
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/iio/kfifo_buf.c       |    4 +++-
 include/linux/iio/kfifo_buf.h |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/kfifo_buf.c b/drivers/iio/kfifo_buf.c
index 7134e8a..5b5387c 100644
--- a/drivers/iio/kfifo_buf.c
+++ b/drivers/iio/kfifo_buf.c
@@ -166,19 +166,21 @@ static const struct iio_buffer_access_funcs kfifo_access_funcs = {
 	.release = &iio_kfifo_buffer_release,
 };
 
-struct iio_buffer *iio_kfifo_allocate(struct iio_dev *indio_dev)
+struct iio_buffer *iio_kfifo_allocate(void)
 {
 	struct iio_kfifo *kf;
 
 	kf = kzalloc(sizeof *kf, GFP_KERNEL);
 	if (!kf)
 		return NULL;
+
 	kf->update_needed = true;
 	iio_buffer_init(&kf->buffer);
 	kf->buffer.attrs = &iio_kfifo_attribute_group;
 	kf->buffer.access = &kfifo_access_funcs;
 	kf->buffer.length = 2;
 	mutex_init(&kf->user_lock);
+
 	return &kf->buffer;
 }
 EXPORT_SYMBOL(iio_kfifo_allocate);
diff --git a/include/linux/iio/kfifo_buf.h b/include/linux/iio/kfifo_buf.h
index 25eeac7..1a8d57a 100644
--- a/include/linux/iio/kfifo_buf.h
+++ b/include/linux/iio/kfifo_buf.h
@@ -5,7 +5,7 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/buffer.h>
 
-struct iio_buffer *iio_kfifo_allocate(struct iio_dev *indio_dev);
+struct iio_buffer *iio_kfifo_allocate(void);
 void iio_kfifo_free(struct iio_buffer *r);
 
 #endif
-- 
1.7.9.5

