Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbaGXHrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:47:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63440 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178AbaGXHrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:47:48 -0400
Date: Thu, 24 Jul 2014 08:47:39 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: [PATCH 0/3] Enable discard on Hyper-V
Message-ID: <20140724074739.GA15127@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
 <20140723141558.GA9705@infradead.org>
 <20140723201341.GA10292@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723201341.GA10292@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:13:41PM +0100, Sitsofe Wheeler wrote:
> On Wed, Jul 23, 2014 at 07:15:58AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 23, 2014 at 03:10:28PM +0100, Sitsofe Wheeler wrote:
> > > I'm not sure this alone will work - won't sdev_bflags/bflags have
> > > already been built at this point?
> > 
> > They've been built up, but we can still or new values into it.  It looks
> > fine to me from review, but if you can test it on an actualy hypverv
> > setup that would be valueable feedback.
> 
> The previous patches didn't work for me with a Windows 2012 R2 host with a
> 3.16.0-rc6.x86_64-00076-g2f7d2ec-dirty guest. After applying
> 
> > term project, this late in the 3.17 cycle I'd just like to merge
> > something that gets discards on hyperv to work.

OK how about the following patches:

Sitsofe Wheeler (3):
  [SCSI] Add quirk for forcing logical block provisioning tests
  [SCSI] storvsc: Add Hyper-V logical block provisioning quirk
  [SCSI] Make LBP quirk skip lbpme checks

 drivers/scsi/scsi_scan.c    |  4 +++-
 drivers/scsi/sd.c           | 12 ++++++++++--
 drivers/scsi/storvsc_drv.c  |  6 ++++++
 include/scsi/scsi_device.h  |  1 +
 include/scsi/scsi_devinfo.h |  2 ++
 5 files changed, 22 insertions(+), 3 deletions(-)

-- 
1.9.3

-- 
Sitsofe | http://sucs.org/~sits/
