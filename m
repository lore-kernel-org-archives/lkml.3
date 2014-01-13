Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaAMQyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:54:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34348 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753557AbaAMQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:11 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/3] iio: mxs-lradc fixes
Date: Mon, 13 Jan 2014 17:02:00 +0100
Message-Id: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few fixes to get in before 3.14.

Two of those are because I wasn't careful engouh when reordering my patch before
thos of Hector, it made me drop a part. and I forgot to reintroduce it when
rebasing.

The first patch fixes a buffer overflow found by smatch.

The second patch doesn't really have any impact as we control the input but is
there for correctness.

The last one removes useless scale_available files for channel 8 and 9 as they
are read has a temperature channel. I feel it is safe to do as no releases were
made with those so we are not really breaking the ABI.

Alexandre Belloni (3):
  iio: mxs-lradc: fix buffer overflow
  iio: mxs-lradc: fix invalid channel number detection
  iio: mxs-lradc: remove useless scale_available files

 drivers/staging/iio/adc/mxs-lradc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

-- 
1.8.3.2

