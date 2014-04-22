Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaDVPKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:10:55 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43919 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaDVPKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:10:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 0/5] drm/tegra: Convert to master/component framework
Date: Tue, 22 Apr 2014 17:09:28 +0200
Message-Id: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Hi,

This series converts the Tegra DRM driver to the master/component
framework. The length of the series and the list of people in Cc is
mostly due to the fact that Tegra has some special requirements as
opposed to other drivers and therefore requires some changes outside
of DRM.

Patches 1 and 2 make some changes to the master/component framework
which are necessary to convert Tegra DRM to use it. Note that since I'm
looking for early review I haven't converted any of the existing users
since I'm not sure if these are acceptable changes.

Patch 3 adds a new interface framework that supplements the master/
component framework and can be used in situations where there is no
struct device * that a driver can bind to.

A new function is introduced in patch 4 which can be used to get rid of
the DRM bus infrastructure in individual drivers. It should be able to
replace the requirement of having a drm_bus for all USB and platform
DRM drivers. For backwards-compatibility with legacy PCI drivers some-
thing different will probably be needed.

Finally, patch 5 converts the Tegra DRM driver over to using the master/
component framework using the above four patches.

Each patch has a somewhat more elaborate description of why it is needed
or what problem it solves. The patchset applies on top of linux-next
with Daniel's DRM cleanup series applied.

I welcome any questions or comments you might have.

Thierry

Thierry Reding (5):
  drivers/base: Allow multiple masters per device
  drivers/base: Allow driver-data to be attached to a master
  drivers/base: Add interface framework
  drm: Introduce drm_set_unique()
  drm/tegra: Convert to master/component framework

 drivers/base/Makefile          |   2 +-
 drivers/base/component.c       |  31 ++-
 drivers/base/interface.c       | 186 ++++++++++++++
 drivers/gpu/drm/drm_ioctl.c    |  37 ++-
 drivers/gpu/drm/drm_stub.c     |   1 +
 drivers/gpu/drm/tegra/Makefile |   1 -
 drivers/gpu/drm/tegra/bus.c    |  64 -----
 drivers/gpu/drm/tegra/dc.c     |  58 ++---
 drivers/gpu/drm/tegra/drm.c    | 171 +++++++++----
 drivers/gpu/drm/tegra/drm.h    |  27 +-
 drivers/gpu/drm/tegra/dsi.c    | 144 +++++------
 drivers/gpu/drm/tegra/gr2d.c   |  78 +++---
 drivers/gpu/drm/tegra/gr3d.c   |  77 +++---
 drivers/gpu/drm/tegra/hdmi.c   |  69 ++---
 drivers/gpu/drm/tegra/sor.c    |  71 ++----
 drivers/gpu/host1x/Makefile    |   1 -
 drivers/gpu/host1x/bus.c       | 553 -----------------------------------------
 drivers/gpu/host1x/bus.h       |  29 ---
 drivers/gpu/host1x/dev.c       |  21 +-
 drivers/gpu/host1x/dev.h       |   7 +-
 include/drm/drmP.h             |   3 +
 include/linux/component.h      |  20 +-
 include/linux/host1x.h         |  64 +----
 include/linux/interface.h      |  40 +++
 24 files changed, 625 insertions(+), 1130 deletions(-)
 create mode 100644 drivers/base/interface.c
 delete mode 100644 drivers/gpu/drm/tegra/bus.c
 delete mode 100644 drivers/gpu/host1x/bus.c
 delete mode 100644 drivers/gpu/host1x/bus.h
 create mode 100644 include/linux/interface.h

-- 
1.9.2

