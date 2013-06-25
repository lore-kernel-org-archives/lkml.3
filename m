Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3FYSeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3FYSe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 93/95] drivers: uio: Fix UIO device registration failure
Date: Tue, 25 Jun 2013 11:33:20 -0700
Message-Id: <20130625182204.176739943@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damian Hobson-Garcia <dhobsong@igel.co.jp>

commit 5ed0505c713805f89473cdc0bbfb5110dfd840cb upstream.

Until recently uio_get_minor() returned 0 for success and
a negative value on failure.  This became non-negative for suceess and
negative for failure.  Restore the original return value spec so that we can
successfully initialize UIO devices with a non-zero minor device
number.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/uio/uio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -374,6 +374,7 @@ static int uio_get_minor(struct uio_devi
 	retval = idr_alloc(&uio_idr, idev, 0, UIO_MAX_DEVICES, GFP_KERNEL);
 	if (retval >= 0) {
 		idev->minor = retval;
+		retval = 0;
 	} else if (retval == -ENOSPC) {
 		dev_err(idev->dev, "too many uio devices\n");
 		retval = -EINVAL;


