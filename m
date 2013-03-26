Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3CZXgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:36:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3CZWoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ryan Mallon <rmallon@gmail.com>, Damien Cassou <damien.cassou@lifl.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 52/98] drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()
Date: Tue, 26 Mar 2013 15:42:41 -0700
Message-Id: <20130326224247.962403327@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hartleys@visionengravers.com>

commit e66b05873a7a76afc569da6382509471cba8d5ff upstream.

Commit be8678149701 ("drivers/video/ep93xx-fb.c: use devm_ functions")
introduced a build error:

  drivers/video/ep93xx-fb.c: In function 'ep93xxfb_probe':
  drivers/video/ep93xx-fb.c:532: error: implicit declaration of function 'devm_ioremap'
  drivers/video/ep93xx-fb.c:533: warning: assignment makes pointer from integer without a cast

Include <linux/io.h> to pickup the declaration of 'devm_ioremap'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Acked-by: Ryan Mallon <rmallon@gmail.com>
Cc: Damien Cassou <damien.cassou@lifl.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/ep93xx-fb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/fb.h>
+#include <linux/io.h>
 
 #include <linux/platform_data/video-ep93xx.h>
 


