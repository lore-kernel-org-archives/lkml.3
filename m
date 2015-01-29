Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbbA2CdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:33:01 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:58260 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbbA2Cc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:32:58 -0500
From: "S. Gilles" <sgilles@terpmail.umd.edu>
X-Google-Original-From: "S. Gilles" <sgilles@umd.edu>
Date: Wed, 28 Jan 2015 21:32:47 -0500
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maik Broemme <mbroemme@plusserver.de>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: i915 framebuffer init too slow to find logo
Message-ID: <20150129023247.GA10967@number16>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 92b004d1aa9f367c372511ca0330f58216b25703 : prevent use of
logs after they have been freed, my i915 machine has no logo on boot
(reverting that commit brings it back on recent trees). My .config
builds nothing but wireless as =m, so I think this is a genuine false
positive (as predicted by the commit). Examining an augmented dmesg,
it appears that the framebuffer setup is too slow by about 0.3s, which
I wouldn't really expect from this system/driver.

Is this slowness considered worth fixing, or is this issue considered
too cosmetic? (Or is this just PEBKAC?)

Possibly useful information:

$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)

>From various printk()s, it looks like the slow portion of
fb_console_init() is restore_fbdev_mode(), specifically
drm_mode_set_config_internal(), which takes about 0.45s, while the
fb_logo_late_init() call happens about 0.15s into that. I can give the
full details if requested.

Possibly relevant .config bits:

# Graphics support
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16

# Direct Rendering Manager
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y

# I2C encoder or helper chips
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y

# Frame buffer Devices
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y

# Frame buffer hardware drivers
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_HDMI=y

# Console display driver support
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

-- 
S. Gilles
