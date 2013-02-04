Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3BDPlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:41:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3BDPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:41:24 -0500
Message-ID: <510FD6A2.80101@canonical.com>
Date: Mon, 04 Feb 2013 16:41:22 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/nouveau: always select ACPI_VIDEO if ACPI is enabled.
References: <20130204152344.GG13909@pd.tnic>
In-Reply-To: <20130204152344.GG13909@pd.tnic>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 04-02-13 16:23, Borislav Petkov schreef:
> Hi,
>
> I'm guessing someone has already triggered this on latest Linus' tree
> and has a fix?
>
> drivers/built-in.o: In function `nouveau_acpi_edid':
> /w/kernel/linux/drivers/gpu/drm/nouveau/nouveau_acpi.c:420: undefined reference to `acpi_video_get_edid'
> make: *** [vmlinux] Error 1
>
> Btw, I got CONFIG_ACPI_VIDEO=m while CONFIG_DRM_NOUVEAU=y and this is
> probably the reason for the vmlinux link error.
>
> Thanks.
>
Does this fix things?

-->8
Having nouveau builtin would still allow ACPI_VIDEO to be used as external module if some of the deps for acpi_video
have not been met, which would result in a linking failure. Solve this by only requiring ACPI && X86 to select ACPI_VIDEO.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 8a55bee..f08b9b6 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -10,7 +10,7 @@ config DRM_NOUVEAU
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
-	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
+	select ACPI_VIDEO if ACPI && X86
 	select ACPI_WMI if ACPI
 	select MXM_WMI if ACPI
 	select POWER_SUPPLY

