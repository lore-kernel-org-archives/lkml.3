Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbbAMC5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:57:42 -0500
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:43666 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbbAMC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:57:07 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] au0828 vb2 conversion
Date: Mon, 12 Jan 2015 19:56:54 -0700
Message-Id: <cover.1421115389.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes patch v3 of the au0828 vb2 conversion,
removing video and vbi buffer timeout handling, and a patch to
fix compile error from au0828_boards initialization which uses a
a define from videobuf-core.h which is no longer included with the
vb2 conversion change.

The following work is in progress and will be done as separate
patches:
- removing users and using v4l2_fh_is_singular_file() instead.
- Changing dynamic allocation of video device structs to static
  which will reduce the overhead to allocate at register time and
  deallocating at unregister.
- New v4l2-compliance tool showed warnings on try_fmt and s_fmt
  because the driver doesn't return error in all cases.

Changes from patch v2:
- Dropped already acked from the v3 series
  [PATCH v2 2/3] media: au0828 change to not zero out fmt.pix.priv
- Split compile error fix and vb2 conversion patches
- Made changes to vb2 conversion patch to address comments on v2
  patch.
- Updated commit log for remove video and vbi buffer timeout
  work-around patch
- Rebased and tested patches on 3.19-rc4

Shuah Khan (3):
  media: fix au0828 compile error from au0828_boards initialization
  media: au0828 - convert to use videobuf2
  media: au0828 remove video and vbi buffer timeout work-around

 drivers/media/usb/au0828/Kconfig        |    2 +-
 drivers/media/usb/au082e/au0828-cards.c |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c   |  122 ++--
 drivers/media/usb/au0828/au0828-video.c | 1005 +++++++++++--------------------
 drivers/media/usb/au0828/au0828.h       |   64 +-
 5 files changed, 414 insertions(+), 781 deletions(-)

-- 
2.1.0

