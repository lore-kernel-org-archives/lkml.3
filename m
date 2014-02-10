Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBJQuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:50:37 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:48511 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaBJQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:50:34 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 0/3] xen-block: changes for discard support
Date: Mon, 10 Feb 2014 17:50:24 +0100
Message-Id: <1392051027-29516-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix blkfront to handle all sorts of backends.

Also let blkback recognize a xenstore property to disable discard for a
given device. It requires upcoming libxl changes ("discard-enable"):
http://lists.xenproject.org/archives/html/xen-devel/2014-01/msg02632.html

Olaf Hering (3):
  xen-blkfront: remove type check from blkfront_setup_discard
  xen blkif.h: fix comment typo in discard-alignment
  xen/blkback: disable discard feature if requested by toolstack

 drivers/block/xen-blkback/xenbus.c |  7 ++++++-
 drivers/block/xen-blkfront.c       | 40 +++++++++++++-------------------------
 include/xen/interface/io/blkif.h   |  2 +-
 3 files changed, 21 insertions(+), 28 deletions(-)

