Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaEGXRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:17:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaEGXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:17:44 -0400
Subject: [RFC PATCH 0/2] iommu: Expose IOMMU information in sysfs
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 17:17:42 -0600
Message-ID: <20140507230308.3124.90856.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users want to know the features of their hardware and we need a better
way to get it than parsing it out of dmesg.  This series adds a simple
registration interface for IOMMUs and an example base implementation
for intel-iommu.

One key hardware feature for device assignment is the IOMMU support
for superpages.  In this example, we can parse it out of the "cap"
attribute exposed, but I expect we'll want to add more human readable
entries for such features.  I'd welcome suggestions on what features
we should pull out into human friendly attributes and how to format
the contents.

I have not attempted to make a common, consistent interface for
attributes between various IOMMU types here.  I'm not entirely sure
such a thing is possible.  Perhaps instead we do like I show in the
intel-iommu example and provide IOMMU driver specific attribute
groups, clearly labeled so that we effectively give each a namespace.
We can promote consistency between drivers, but a common namespace
is probably best left to userspace tools.

Appreciate any thoughts and comments.  Thanks,

Alex

---

Alex Williamson (2):
      iommu: Add sysfs support for IOMMUs
      iommu/intel: Make use of IOMMU sysfs support


 drivers/iommu/Makefile      |    1 
 drivers/iommu/dmar.c        |    8 ++
 drivers/iommu/intel-iommu.c |   75 ++++++++++++++++++++++
 drivers/iommu/iommu-sysfs.c |  147 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h |    2 +
 include/linux/iommu.h       |   28 ++++++++
 6 files changed, 260 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommu-sysfs.c
