Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbbAHQk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:40:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64764 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbbAHQku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:40:50 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ef-54aeb310f613
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 0/2] iio: Add no-triggered buffer helper functions
Date: Thu, 08 Jan 2015 17:40:25 +0100
Message-id: <1420735227-21091-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7oCm9eFGHw9zmyxccZ6VosHTauY
	LE4t289ksev/G2aLs01v2C2WTJ7PajHvyDsWi8u75rBZ/N51jN1iz7otTA5cHjtn3WX3+PAx
	zmPTqk42jyVvDrF6nG8+wujRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGcd/dbAWvOWq2DZl
	NmMD436OLkZODgkBE4nNG3YzQthiEhfurWcDsYUEljJKnDua3MXIBWT3MUmsuL6CCSTBJqAu
	0bxjMTNIQkTgAqPE8UNbWEAcZoE1jBJnzk5gB6kSFnCSaD58gxnEZhFQlZh+4CYLiM0r4Cwx
	+8RWoDgH0DoFiTmTbCYwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJWX3YwLj5m
	dYhRgINRiYf3w/21IUKsiWXFlbmHGCU4mJVEeHU814UI8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YDRjabzruiV5GgevnVPumUUV9zgFHVNvB7P8S13es3nFV8uY0sJ/T6f/4Tj4f6J30frtrUuk
	+Zx3RRWef7/4ZhjnxllRx4USPk3M4fyT+P1On+2aC5qbxV64LNjr9GvG+sjyDze9Cg82Kqz9
	YZPtMCutb0We9v5J5+ae+ndritmH/a9SZsZMszJSYinOSDTUYi4qTgQAGQkkWAkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This small patchset introduces helpers for iio kfifo which are useful when
IIO_HARDWARE/SOFTWARE_BUFFER is used.  I decided to do it similar to Lars'
industrialio-triggered-buffer as a separate module what can be considered
as overkill but there is some risk that this source file will grow as new
needs will appear.  Also it gives some flexibility with buffer handling choice.

Second patch deselect IIO_TRIGGER for iio kfifo.  I think that there is no need
to use triggers always when iio kfifo is used and IIO_TRIGGERED_BUFFER also
selects IIO_KFIFO_BUF.  I need some comments for this one to be sure if I do not
missed something.  TI's AM335X ADC driver uses kfifo directly but without
triggered buffer/trigger in its sources so I hope there should be no problem
with that.

Thanks,
Karol

Karol Wrona (2):
  iio: Add no-triggered buffer helper functions
  iio: Deselect IIO_TRIGGER for IIO_KFIFO_BUF

 drivers/iio/Kconfig                           |    7 ++-
 drivers/iio/Makefile                          |    1 +
 drivers/iio/industrialio-notriggered-buffer.c |   72 +++++++++++++++++++++++++
 include/linux/iio/notriggered-buffer.h        |   11 ++++
 4 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iio/industrialio-notriggered-buffer.c
 create mode 100644 include/linux/iio/notriggered-buffer.h

-- 
1.7.9.5

