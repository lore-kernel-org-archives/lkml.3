Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaLSRkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:40:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31147 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaLSRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:40:53 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d3-549463237b0a
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 0/3] iio: Add resource management kfifo alloc/free
Date: Fri, 19 Dec 2014 18:39:23 +0100
Message-id: <1419010766-13557-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xa7rKyVNCDPp2iFhsnLGe1eJB0yom
	i1PL9jNZ7Pr/htnibNMbdoslk+ezWsw78o7F4vKuOWwWv3cdY7fYs24LkwOXx85Zd9k9PnyM
	89i0qpPNY8mbQ6we55uPMHr0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxvtH11kLfnNULF/w
	namB8QJbFyMHh4SAicSDTVZdjJxAppjEhXvrgcJcHEICSxkl9s/rgXL6mCQeb3jDDFLFJqAu
	0bxjMTNIQkTgAqPE8UNbWEAcZoE1jBJnzk5gB6kSFnCV6O2bwARiswioSvw9PgPM5hVwlvgy
	7QM7xGoFiTmTbCYwci9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJWX3cwLj1mdYhR
	gINRiYf3Q+PkECHWxLLiytxDjBIczEoivIbuU0KEeFMSK6tSi/Lji0pzUosPMTJxcEo1MPpk
	cjRemtO051OgiOOepAO+Ky8IXHzJWGrEGaEwf/fyeoPC6VffbDv+J8spgtMw7vl0c/lzeXq5
	e0WZv36a0z3tcJ7IGZOdG84nuPlIluRkZWTvEnqVoW1VfLRP8Av76X+/t9rolSQm2wc8kjrQ
	lfqoee/BX/F98RyN8x58W6U/pTz+c8bmLiWW4oxEQy3mouJEAOwOMg8JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

iio kfifo alloc took one argument struct iio_dev * indio_dev which was not used 
so it was removed in allocate function and in several drivers which used it.
Second patch adds devm_ alloc/free.

Karol

changes from RFC:
- rebased on next-20141219
- changes in clients
- add minor doc fix to iio core


Karol Wrona (3):
  iio: kfifo: Remove unused argument in iio_kfifo_allocate
  iio: kfifo: Add resource management devm_iio_kfifo_allocate/free
  iio: core: Get rid of misleading comment

 drivers/iio/adc/ti_am335x_adc.c                 |    2 +-
 drivers/iio/industrialio-core.c                 |    1 -
 drivers/iio/industrialio-triggered-buffer.c     |    2 +-
 drivers/iio/kfifo_buf.c                         |   60 ++++++++++++++++++++++-
 drivers/staging/iio/accel/lis3l02dq_ring.c      |    2 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c   |    2 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
 drivers/staging/iio/meter/ade7758_ring.c        |    2 +-
 include/linux/iio/kfifo_buf.h                   |    5 +-
 9 files changed, 68 insertions(+), 10 deletions(-)

-- 
1.7.9.5

