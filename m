Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3AYAms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:42:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47024 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab3AYAmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:42:40 -0500
Date: Fri, 25 Jan 2013 00:42:37 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [git pull] fbcon locking fixes.
Message-ID: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

These patches have been sailing around long enough, waiting for a maintainer
to reappear, so I've decided enough is enough, lockdep is kinda useful to have.

Thanks to Daniel for annoying me enough :-)

Dave 'not the fbdev maintainer' Airlie.

The following changes since commit ba2ab41f3d68f277860768b2c5b197768b196332:

  Merge tag 'pm+acpi-for-3.8-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2013-01-24 10:19:13 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux fbcon-locking-fixes

for you to fetch changes up to a9d2331a8eccc17408abd5a7cd3e463745254d65:

  fb: Yet another band-aid for fixing lockdep mess (2013-01-25 10:34:49 +1000)

----------------------------------------------------------------
Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Takashi Iwai (1):
      fb: Yet another band-aid for fixing lockdep mess

 drivers/tty/vt/vt.c           | 134 ++++++++++++++++++++++++++++++------------
 drivers/video/console/fbcon.c |  33 ++++++++++-
 drivers/video/fbmem.c         |   9 ++-
 drivers/video/fbsysfs.c       |   3 +
 include/linux/console.h       |   2 +
 include/linux/vt_kern.h       |   2 +
 6 files changed, 140 insertions(+), 43 deletions(-)
