Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3LLSrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:47:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3LLSrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:47:12 -0500
Subject: [PATCH 0/2] vfio: convert to misc driver
To: alex.williamson@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 12 Dec 2013 11:47:11 -0700
Message-ID: <20131212184402.966.34502.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control device is pretty easily converted to a misc driver with
static minor number which allows us to support auto load.  I've
submitted a request to lanana for the minor number reservation, so
this is mostly FYI until that's approved.  Comments and reviews
welcome.  Thanks,

Alex

---

Alex Williamson (2):
      misc: Reserve minor for VFIO
      vfio: Convert control interface to misc driver


 Documentation/devices.txt  |    1 +
 drivers/vfio/vfio.c        |   70 +++++++++++++++++++++-----------------------
 include/linux/miscdevice.h |    1 +
 3 files changed, 35 insertions(+), 37 deletions(-)
