Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3ETFnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 01:43:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:55268 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3ETFnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 01:43:40 -0400
X-Spam-Score: -100.8
Message-ID: <5199B7D6.40907@asianux.com>
Date: Mon, 20 May 2013 13:42:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64: kernel: need extern variable 'screen_info' for related
 driver using.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add the extern variable 'screen_info' according to arm32 has done.

The related error:
  drivers/video/console/vgacon.c:1305: undefined reference to `screen_info'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/kernel/setup.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index add6ea6..1055992 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -374,3 +374,14 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= c_show
 };
+
+#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
+struct screen_info screen_info = {
+	.orig_video_lines	= 30,
+	.orig_video_cols	= 80,
+	.orig_video_mode	= 0,
+	.orig_video_ega_bx	= 0,
+	.orig_video_isVGA	= 1,
+	.orig_video_points	= 8
+};
+#endif
-- 
1.7.7.6
