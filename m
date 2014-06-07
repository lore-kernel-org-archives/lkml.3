Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaFGBnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:43:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.756029732@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 67/92] [media] V4L2: ov7670: fix a wrong index,
 potentially Oopsing the kernel from user-space
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust filename
 - win_sizes array is static, not per-device]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -937,7 +937,7 @@ static int ov7670_enum_framesizes(struct
 	 * windows that fall outside that.
 	 */
 	for (i = 0; i < N_WIN_SIZES; i++) {
-		struct ov7670_win_size *win = &ov7670_win_sizes[index];
+		struct ov7670_win_size *win = &ov7670_win_sizes[i];
 		if (info->min_width && win->width < info->min_width)
 			continue;
 		if (info->min_height && win->height < info->min_height)

