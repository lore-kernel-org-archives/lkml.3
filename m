Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3EBPQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3EBPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCH, RFC 06/22] gpu/drm: host1x: add dependency on Tegra
Date: Thu,  2 May 2013 17:16:10 +0200
Message-Id: <1367507786-505303-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hIzQirefdEKlmH0BhMXkfr9lhr+KLjVliI+TwUs/wLH
 eqBYWi+M4kBCNsZVay2hnabyG2yEjhr4ec2kuqyYJnYtu4uhUu
 cq6I3LT9zfhYEQh5pPqjqJ9iOqqaRVHgjYsepewT/eH6VRnAi0
 gkIe/OiguapDLjRBBD364r0Me/zeCqLChjjLCaIikbrMm1+Mgh
 Cbd17udqwdz5m66mrS8viQXKs6zOkfOYWudGr/RK8i1VBs4mtu
 ijcTn3MhV3m4H/1vl+SNJPSvhlX8+bs2HFBMORw+TGKKU7B+4L
 Su4qzemJxs4OwZO/UkKokgnk53BYTL5PF4dYLP5t0z5zyNmrNI
 WSD8wwCZK+qdTEzI5BlkfB5qUlNNvIujKEs0wjbPL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we try to make drivers platform independent, this driver currently
calls into an exported interface that is only provided on its own
platform, so we have to add the dependency.

drivers/built-in.o: In function `tegra_crtc_prepare':
 drivers/gpu/host1x/drm/dc.c:650: undefined reference to `tegra_periph_reset_deassert'
drivers/built-in.o: In function `tegra_output_hdmi_disable':
 drivers/gpu/host1x/drm/hdmi.c:840: undefined reference to `tegra_periph_reset_assert'
drivers/built-in.o: In function `tegra_output_hdmi_enable':
 drivers/gpu/host1x/drm/hdmi.c:651: undefined reference to `tegra_periph_reset_assert'
 drivers/gpu/host1x/drm/hdmi.c:653: undefined reference to `tegra_periph_reset_deassert'

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arto Merilainen <amerilainen@nvidia.com>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/host1x/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/host1x/drm/Kconfig b/drivers/gpu/host1x/drm/Kconfig
index 69853a4..5a6a5cd 100644
--- a/drivers/gpu/host1x/drm/Kconfig
+++ b/drivers/gpu/host1x/drm/Kconfig
@@ -1,6 +1,7 @@
 config DRM_TEGRA
 	bool "NVIDIA Tegra DRM"
 	depends on DRM
+	depends on ARCH_TEGRA
 	select DRM_KMS_HELPER
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
-- 
1.8.1.2

