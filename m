Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3JCO54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:57:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63592 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3JCO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:57:54 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-4b-524d85d53af6
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] staging:iio: fix wrong usage of dev_set_name()
Date: Thu, 03 Oct 2013 23:57:21 +0900
Message-id: <1380812241-11589-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWyRsSkWPdqq2+Qwb3F2hZz1q9hs3jQtIrJ
	Yt6RdywWl3fNYbNYsKfEgdVj06pONo8TM36zePRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	uj+GBX/YKt6f+8LcwPibtYuRk0NCwETi0621jBC2mMSFe+vZQGwhgaWMEi87i2Fqtn/fydTF
	yAUUn84oMWn9RGYIp41JYsnMb2AdbAK6Ek8OXGYGsUUEQiTadz4D28AskCZxYH4HO4gtLGAv
	8eTJdLBtLAKqEqsbG8FqeAU8JI53PQKawwG0TUFiziQbkPkSAq/ZJLZ+fswOUS8g8W3yIRaI
	GlmJTQeYIY6TlDi44gbLBEbBBYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECQ/L0v2cT
	dzDeP2B9iDEZaNxEZinR5HxgSOeVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgfH0vHiB3mZW150LJU5MtGGbdO1tWd2GyYtDXd4U58780h1+ui3O
	e8PNSwduPHQv+7hv9utPBoJfzIOcuvjk826+fd+iEt5mNqWL8YzP9bqTL/JMm0w1b4tpba1w
	VS29oaSw9ehHjpPW2TuEm80ebyh3XCl38tvCt7zJYf0r1zzwm+RrknJ+e4gSS3FGoqEWc1Fx
	IgANbP48XwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd2rrb5BBj+3q1jMWb+GzeJB0yom
	i3lH3rFYXN41h81iwZ4SB1aPTas62TxOzPjN4tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhDWMGev+GBb8Yat4f+4LcwPjb9YuRk4OCQETie3fdzJB2GIS
	F+6tZ+ti5OIQEpjOKDFp/URmCKeNSWLJzG9sIFVsAroSTw5cZgaxRQRCJNp3PgObxCyQJnFg
	fgc7iC0sYC/x5Ml0RhCbRUBVYnVjI1gNr4CHxPGuR0BzOIC2KUjMmWQzgZF7ASPDKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzgkH8mtYNxZYPFIUYBDkYlHl6BWt8gIdbEsuLK3EOMEhzM
	SiK8bFVAId6UxMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucD4zGvJN7Q2MTMyNLI3NDCyNicNGEl
	cd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhZ7S/srHsXF316Ri/X3tv9ctd3O0VkrjeS5Ps+
	maFNTNzsxEQXr8qtQko1/KcSnzme6d209u4i7ilnLqfs+BRw+Pg3za7Vs0NWlLGdcOmcOP3L
	Kt3nZ+NXXdWotvsfdago93+ajqRLr+uq+YdtSvN2XrvddOf+OeU01aj6Tyn+NxVe3pz05sIV
	JZbijERDLeai4kQAsDjXf70CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter of dev_set_name() is format string. In order to
avoid any potential accidents such as segmentation fault, basic format
parameter "%s" should be used in this case.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/staging/iio/iio_dummy_evgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/iio_dummy_evgen.c b/drivers/staging/iio/iio_dummy_evgen.c
index 132d278..2c06d16 100644
--- a/drivers/staging/iio/iio_dummy_evgen.c
+++ b/drivers/staging/iio/iio_dummy_evgen.c
@@ -205,7 +205,7 @@ static __init int iio_dummy_evgen_init(void)
 	if (ret < 0)
 		return ret;
 	device_initialize(&iio_evgen_dev);
-	dev_set_name(&iio_evgen_dev, "iio_evgen");
+	dev_set_name(&iio_evgen_dev, "%s", "iio_evgen");
 	return device_add(&iio_evgen_dev);
 }
 module_init(iio_dummy_evgen_init);
-- 
1.7.9.5

