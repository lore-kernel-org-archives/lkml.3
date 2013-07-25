Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3GYTXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:23:02 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:65421 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756883Ab3GYTXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:23:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 20:22:48 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130725192248.GA13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>
References: <20130725170144.GE6493@cantiga.alporthouse.com>
 <CA+icZUUOmoFY3JDZOYmiP3dV9KAR_8WYfEDQhaynKmhXCLpF9w@mail.gmail.com>
 <20130725172616.GA11514@cantiga.alporthouse.com>
 <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
 <CA+icZUXz+6MgbW952fU_da1-RfX8CSZp76gJnOwGDNsd-rdebA@mail.gmail.com>
 <CA+icZUV+D8PvEysipfg9nPXp3ON1QSA7DiFdpYFpdesFF5c0sw@mail.gmail.com>
 <20130725184504.GC11514@cantiga.alporthouse.com>
 <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
 <20130725190006.GD11514@cantiga.alporthouse.com>
 <CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:12:41PM +0200, Sedat Dilek wrote:
> New -3 dmesg.

That puts the ball back in the ddx's court. Next debugging patch:

diff --git a/src/intel_driver.c b/src/intel_driver.c
index f4d76bb..1f4f299 100644
--- a/src/intel_driver.c
+++ b/src/intel_driver.c
@@ -170,6 +170,7 @@ static Bool i830CreateScreenResources(ScreenPtr screen)
 		return FALSE;
 
 	intel_copy_fb(scrn);
+	ErrorF("%s: Success\n", __func__);
 	return TRUE;
 }
 
diff --git a/src/intel_uxa.c b/src/intel_uxa.c
index 2f14173..6be7ebe 100644
--- a/src/intel_uxa.c
+++ b/src/intel_uxa.c
@@ -1150,11 +1150,15 @@ Bool intel_uxa_create_screen_resources(ScreenPtr screen)
 	intel_screen_private *intel = intel_get_screen_private(scrn);
 	dri_bo *bo = intel->front_buffer;
 
-	if (!uxa_resources_init(screen))
+	if (!uxa_resources_init(screen)) {
+		ErrorF("bang: %d\n", __LINE__);
 		return FALSE;
+	}
 
-	if (drm_intel_gem_bo_map_gtt(bo))
+	if (drm_intel_gem_bo_map_gtt(bo)) {
+		ErrorF("bang: %d\n", __LINE__);
 		return FALSE;
+	}
 
 	pixmap = screen->GetScreenPixmap(screen);
 	intel_set_pixmap_bo(pixmap, bo);
@@ -1167,8 +1171,10 @@ Bool intel_uxa_create_screen_resources(ScreenPtr screen)
 				   NULL);
 	scrn->displayWidth = intel->front_pitch / intel->cpp;
 
-	if (!intel_glamor_create_screen_resources(screen))
+	if (!intel_glamor_create_screen_resources(screen)) {
+		ErrorF("bang: %d\n", __LINE__);
 		return FALSE;
+	}
 
 	return TRUE;
 }

-- 
Chris Wilson, Intel Open Source Technology Centre
