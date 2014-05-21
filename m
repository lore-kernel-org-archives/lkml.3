Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaEUOjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:39:32 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:17555 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaEUOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:39:31 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 10:39:31 EDT
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH RESEND 0/3] xen-block: changes for discard support
Date: Wed, 21 May 2014 16:32:39 +0200
Message-Id: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix blkfront to handle all sorts of backends.

Also let blkback recognize a xenstore property to disable discard for a
given device. This part requires libxl changes ("discard-enable"):
http://lists.xenproject.org/archives/html/xen-devel/2014-05/msg02291.html

(This is a resend, this series was already sent 2014-02-10.)

Olaf Hering (3):
  xen-blkfront: remove type check from blkfront_setup_discard
  xen blkif.h: fix comment typo in discard-alignment
  xen/blkback: disable discard feature if requested by toolstack

 drivers/block/xen-blkback/xenbus.c |  7 ++++++-
 drivers/block/xen-blkfront.c       | 40 +++++++++++++-------------------------
 include/xen/interface/io/blkif.h   |  2 +-
 3 files changed, 21 insertions(+), 28 deletions(-)

