Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJJHtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:49:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59178 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJJHtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:49:08 -0400
Date: Fri, 10 Oct 2014 08:49:01 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Message-ID: <20141010074901.GA32028@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance
even though they implement post SPC-2 features (such as thin
provisioning) which means the Linux kernel does not go on to test for
those features even though they are advertised.

A previous patch attempted to add a quirk to workaround this but the
quirk was only enabled after the features had been scanned for, wouldn't
work for "small" disks and would quirk on  all Hyper-V SCSI devices
(e.g. passthrough disks).

The new patches partially revert the previous effort, add the quirk in a
more traditional manner to only Hyper-V virtual disks and work on small
virtual disks.

Sitsofe Wheeler (3):
  Revert "Drivers: add blist flags"
  scsi: add try_rc16 blacklist flag
  scsi: Use try_rc16 and try_vpd_pages quirks on Hyper-V virtual disks

 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/scsi_scan.c    |  3 +++
 drivers/scsi/sd.c           |  3 +++
 drivers/scsi/storvsc_drv.c  | 10 ----------
 include/scsi/scsi_device.h  |  1 +
 include/scsi/scsi_devinfo.h |  1 +
 6 files changed, 9 insertions(+), 10 deletions(-)

-- 
1.9.3

