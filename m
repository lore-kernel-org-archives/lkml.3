Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaFDXX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaFDXXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 227/228] media: V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
Date: Wed,  4 Jun 2014 16:24:16 -0700
Message-Id: <20140604232355.338599245@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit cfece5857ca51d1dcdb157017aba226f594e9dcf upstream.

Commit 75e2bdad8901a0b599e01a96229be922eef1e488 "ov7670: allow
configuration of image size, clock speed, and I/O method" uses a wrong
index to iterate an array. Apart from being wrong, it also uses an
unchecked value from user-space, which can cause access to unmapped
memory in the kernel, triggered by a normal desktop user with rights to
use V4L2 devices.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov7670.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1109,7 +1109,7 @@ static int ov7670_enum_framesizes(struct
 	 * windows that fall outside that.
 	 */
 	for (i = 0; i < n_win_sizes; i++) {
-		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
+		struct ov7670_win_size *win = &info->devtype->win_sizes[i];
 		if (info->min_width && win->width < info->min_width)
 			continue;
 		if (info->min_height && win->height < info->min_height)


