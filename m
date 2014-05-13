Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaEMPdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:33:46 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40291 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaEMPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:33:06 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] drm: Document how to register devices without struct drm_bus
Date: Tue, 13 May 2014 17:30:50 +0200
Message-Id: <1399995050-28435-8-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

With the recent addition of the drm_set_unique() function, devices can
now be registered without requiring a drm_bus. Add a brief description
to the DRM docbook to show how that can be achieved.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/DocBook/drm.tmpl | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
index f26a8e4fbe47..f48227caf41a 100644
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
@@ -142,6 +142,12 @@
       to register it with the DRM subsystem.
     </para>
     <para>
+      Newer drivers that no longer require a <structname>drm_bus</structname>
+      structure can alternatively use the low-level device initialization and
+      registration functions such as <function>drm_dev_alloc()</function> and
+      <function>drm_dev_register()</function> directly.
+    </para>
+    <para>
       The <structname>drm_driver</structname> structure contains static
       information that describes the driver and features it supports, and
       pointers to methods that the DRM core will call to implement the DRM API.
@@ -290,6 +296,29 @@ char *date;</synopsis>
 !Fdrivers/gpu/drm/drm_pci.c drm_pci_init drm_pci_exit
 !Fdrivers/gpu/drm/drm_usb.c drm_usb_init drm_usb_exit
 !Fdrivers/gpu/drm/drm_platform.c drm_platform_init
+      <para>
+        New drivers that no longer rely on the services provided by the
+        <structname>drm_bus</structname> structure can call the low-level
+        device registration functions directly. The
+        <function>drm_dev_alloc()</function> function can be used to allocate
+        and initialize a new <structname>drm_device</structname> structure.
+        Drivers will typically want to perform some additional setup on this
+        structure, such as allocating driver-specific data and storing a
+        pointer to it in the DRM device's <structfield>dev_private</structfield>
+        field. Drivers should also set the device's unique name using the
+        <function>drm_set_unique()</function> function. After it has been set up
+        a device can be registered with the DRM subsystem by calling
+        <function>drm_dev_register()</function>. This will cause the device to
+        be exposed to userspace and will call the driver's
+        <structfield>.load()</structfield> implementation. When a device is
+        removed, the DRM device can safely be unregistered and freed using a
+        call to <function>drm_put_dev()</function>.
+      </para>
+!Fdrivers/gpu/drm/drm_stub.c drm_dev_alloc
+!Fdrivers/gpu/drm/drm_stub.c drm_set_unique
+!Fdrivers/gpu/drm/drm_stub.c drm_dev_register
+!Fdrivers/gpu/drm/drm_stub.c drm_put_dev
+    </sect2>
     <sect2>
       <title>Driver Load</title>
       <para>
-- 
1.9.2

