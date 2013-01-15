Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533Ab3AOW6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:58:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:48786 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265Ab3AOW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:58:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        John Tapsell <johnflux@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ 69/71] Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
Date: Tue, 15 Jan 2013 14:55:06 -0800
Message-Id: <20130115225345.373359670@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 48e858340dae43189a4e55647f6eac736766f828 upstream.

This reverts commit 9756fe38d10b2bf90c81dc4d2f17d5632e135364.

The bogus lvds output is actually a lvds->hdmi bridge, which we don't
really support. But unconditionally disabling it breaks some existing
setups.

Reported-by: John Tapsell <johnflux@gmail.com>
References: http://permalink.gmane.org/gmane.comp.freedesktop.xorg.drivers.intel/17237
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/intel_lvds.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -753,14 +753,6 @@ static const struct dmi_system_id intel_
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
-		.ident = "ZOTAC ZBOXSD-ID12/ID13",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ZOTAC"),
-			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
-		},
-	},
-	{
-		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Gigabyte GA-D525TUD",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),


