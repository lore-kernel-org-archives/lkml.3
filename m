Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaLITaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:30:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29267 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaLITaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:30:22 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-bb-54874dcac478
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [RFC PATCH 0/2] iio: kfifo: Add resource management alloc/free
Date: Tue, 09 Dec 2014 20:29:43 +0100
Message-id: <1418153385-18212-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xy7qnfNtDDLq3WltsnLGe1eJB0yom
	i1PL9jNZ7Pr/htnibNMbdot5R96xWFzeNYfNYs+6LUwOHB47Z91l9/jwMc5j06pONo++LasY
	PT5vkgtgjeKySUnNySxLLdK3S+DKuPBjNXvBDI6KCT/+sTUwHmXrYuTkkBAwkTj3Zg6ULSZx
	4d56IJuLQ0hgKaPEnXu32CGcPiaJ1Yu/MoNUsQmoSzTvWMwMkhARaGGUePFzFyuIwyywhlHi
	zNkJ7CBVwgLuEqv6lrOA2CwCqhJfJx8H28Er4Czx/fYhoG4OoH0KEnMm2Uxg5F7AyLCKUTS1
	NLmgOCk911CvODG3uDQvXS85P3cTIyRgvuxgXHzM6hCjAAejEg+vuWJriBBrYllxZe4hRgkO
	ZiUR3rUs7SFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGLPyHk3VVf+z8veO5l2qmtcuy0kJvTrx
	7ZjSpzfqH2dsryjh81ziaD9LevbMyTe2sRUJ2HAu6k1b/GnO9Zq578MZ8gx+dNQr/PBx1gxk
	PHuhVDb236J08QLxOduLPb+4Z9ir2Jdtb3TN4hO0W58Z4ynybdv/CYJqvMrnfjG/mbPwDPvp
	spKeSiWW4oxEQy3mouJEAFrQMFn2AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is RFC because I felt a bit confused while devm_alloc/free adding.
It applies on next but I've tested it partialy on 3.16.  It can cause some
problemsi with several drivers so it does not fit for now. 

iio kfifo alloc takes one argument struct iio_dev * which is not used.
iio_buffer is attached by external function.  In such situation resource 
management alloc can be implemented in two ways:
1. indio_dev ptr in iio_kfifo_alloc stays and devm_ functions have to
provide it but it is still unused.
2.  As there are a few drivers which use kfifo it can be removed and 
iio_kfifo_allocate refactored.

I apologise if I missed something and it was done in such way intentionally.



Karol Wrona (2):
  iio: kfifo: Remove unused argument in iio_kfifo_allocate
  iio: kfifo: Add resource management devm_iio_kfifo_allocate/free

 drivers/iio/kfifo_buf.c       |   58 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/iio/kfifo_buf.h |    5 +++-
 2 files changed, 61 insertions(+), 2 deletions(-)

-- 
1.7.9.5

