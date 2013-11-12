Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3KLONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:13:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27461 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab3KLOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:12:58 -0500
X-IronPort-AV: E=Sophos;i="4.93,685,1378857600"; 
   d="scan'208";a="73570048"
Date: Tue, 12 Nov 2013 14:11:21 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH 0/2] swiotlb-xen fixes
Message-ID: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is just a couple of fixes for swiotlb-xen.

In particular the slow path (bouncing on the swiotlb buffer for dma
operations) on ARM has two problems, each of them fixed by a separate
patch:

- a xen_dma_map_page call is missing in xen_swiotlb_map_sg_attrs;

- dma_capable often fails on ARM because devices don't set the dma_mask
  correctly. This causes swiotlb-xen to take the slow path, and that is
  bad enough, but in xen_swiotlb_map_page also causes the function to
  return an error an fail.



Stefano Stabellini (2):
      swiotlb-xen: add missing xen_dma_map_page call
      swiotlb-xen: xen_swiotlb_map_page: do not error out if dma_capable fails

 drivers/xen/swiotlb-xen.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)


git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git for-linus-3.13-fixes

Cheers,

Stefano
