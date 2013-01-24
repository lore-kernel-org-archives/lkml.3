Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3AXWEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:04:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab3AXWEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:04:01 -0500
Subject: [PATCH 0/2] kvm: IOMMU read-only mapping support
To: gleb@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Date: Thu, 24 Jan 2013 15:03:57 -0700
Message-ID: <20130124220027.11061.76400.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple patches to make KVM IOMMU support honor read-only mappings.
This causes an un-map, re-map when the read-only flag changes and
makes use of it when setting IOMMU attributes.  Thanks,

Alex

---

Alex Williamson (2):
      kvm: Force IOMMU remapping on memory slot read-only flag changes
      kvm: Obey read-only mappings in iommu


 virt/kvm/iommu.c    |    4 +++-
 virt/kvm/kvm_main.c |   28 ++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 5 deletions(-)
