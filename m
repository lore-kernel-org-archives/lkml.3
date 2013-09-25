Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3IYAQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3IYAQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 079/110] media: v4l2: added missing mutex.h include to v4l2-ctrls.h
Date: Tue, 24 Sep 2013 17:15:17 -0700
Message-Id: <20130925001331.976534794@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <a.hajda@samsung.com>

commit a19dec6ea94c036af68c31930c1c92681f55af41 upstream.

This patch fixes following error:
include/media/v4l2-ctrls.h:193:15: error: field ‘_lock’ has incomplete type
include/media/v4l2-ctrls.h: In function ‘v4l2_ctrl_lock’:
include/media/v4l2-ctrls.h:570:2: error: implicit declaration of
	function ‘mutex_lock’ [-Werror=implicit-function-declaration]
include/media/v4l2-ctrls.h: In function ‘v4l2_ctrl_unlock’:
include/media/v4l2-ctrls.h:579:2: error: implicit declaration of
	function ‘mutex_unlock’ [-Werror=implicit-function-declaration]

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/media/v4l2-ctrls.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,6 +22,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 
 /* forward references */


