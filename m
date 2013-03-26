Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab3CZBbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:31:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41034 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3CZBbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:31:37 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH] drivers: uio: Fix UIO device registration failure
Date: Tue, 26 Mar 2013 10:31:22 +0900
Message-Id: <1364261482-19160-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until recently uio_get_minor() returned 0 for success and
a negative value on failure.  This became non-negative for suceess and
negative for failure.  Restore the original return value spec so that we can
successfully initialize UIO devices with a non-zero minor device
number.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 drivers/uio/uio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index c8b9262..b645c47 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -374,6 +374,7 @@ static int uio_get_minor(struct uio_device *idev)
 	retval = idr_alloc(&uio_idr, idev, 0, UIO_MAX_DEVICES, GFP_KERNEL);
 	if (retval >= 0) {
 		idev->minor = retval;
+		retval = 0;
 	} else if (retval == -ENOSPC) {
 		dev_err(idev->dev, "too many uio devices\n");
 		retval = -EINVAL;
-- 
1.7.5.4

