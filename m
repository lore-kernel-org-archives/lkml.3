Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3KESlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:41:49 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:60104 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab3KESlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:41:47 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Date: Tue,  5 Nov 2013 20:41:35 +0200
Message-Id: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset introduces Device Tree overlays, a method
of dynamically altering the kernel's live Device Tree, along with
a generic interface to use it in a board agnostic manner.

It is against mainline as of today, Nov 5 2013:
	be408cd3e1fef73e9408b196a79b9934697fe3b1 
	Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net

It relies on the following previously submitted patches/patchsets:

The DTC compiler patch required to get symbol resolution working

	"dtc: Dynamic symbols & fixup support (v2)"

The I2C device registration patch

	"of: i2c: Export single device registration method"

And finally a patchset exporting various OF fixes

	"OF: Fixes in preperation of DT overlays"

Note that although this patchset allows DT overlay removal
on my preferred platform (omap), platform device registration
fails; another patchset that deals with this issue has been posted:

	"omap_device removal fixups"

I should also note that the /proc interface is an anachronism, but
it is the place where /proc/device-tree is also located, so it makes
sense to group /proc/device-tree & /proc/device-tree-overlay* together.
I am open to suggestions about where the generic interface should reside.
A suggestion has been made about configfs but I'd like to get this out
as a basis of discussion.

This low level interface should be used as a starting point for platforms
with discoverable hardware on the daughtercard level since they should use the
facilities provided to implement their own policy, dealing with things like
conflicts, high level resource allocation and so on.

Changes since V1:

* Removal of any bits related to a specific board (beaglebone).
* Introduced a platform agnostic interface using /proc/device-tree-overlay
* Various bug fixes related to i2c device handling have been squashed in.

Pantelis Antoniou (3):
  OF: Introduce Device Tree resolve support.
  OF: Introduce DT overlay support.
  DT: proc: Add runtime overlay interface in /proc

 .../devicetree/dynamic-resolution-notes.txt        |  25 +
 Documentation/devicetree/overlay-notes.txt         | 179 +++++
 drivers/of/Kconfig                                 |  19 +
 drivers/of/Makefile                                |   2 +
 drivers/of/overlay.c                               | 869 +++++++++++++++++++++
 drivers/of/resolver.c                              | 395 ++++++++++
 fs/proc/proc_devtree.c                             | 278 +++++++
 include/linux/of.h                                 | 130 +++
 8 files changed, 1897 insertions(+)
 create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
 create mode 100644 Documentation/devicetree/overlay-notes.txt
 create mode 100644 drivers/of/overlay.c
 create mode 100644 drivers/of/resolver.c

-- 
1.7.12

