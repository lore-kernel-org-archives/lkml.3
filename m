Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbaFEAnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:43:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaFDXVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 038/228] drivers/rtc/rtc-hym8563.c: set uie_unsupported
Date: Wed,  4 Jun 2014 16:21:07 -0700
Message-Id: <20140604232349.304867712@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

commit 282cba6b00a95f0277ed71551e3f6b0477e8836b upstream.

The alarm of the hym8563 only supports a minute accuracy, while the uie
wants an alarm one second in the future.  Therefore things like the
select() syscall will fail with a timeout, because the next alarm will
happen in a worst case of 60 seconds.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-hym8563.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -569,6 +569,9 @@ static int hym8563_probe(struct i2c_clie
 	if (IS_ERR(hym8563->rtc))
 		return PTR_ERR(hym8563->rtc);
 
+	/* the hym8563 alarm only supports a minute accuracy */
+	hym8563->rtc->uie_unsupported = 1;
+
 #ifdef CONFIG_COMMON_CLK
 	hym8563_clkout_register_clk(hym8563);
 #endif


