Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbaJHNGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:06:01 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17183 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbaJHNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:05:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,677,1406592000"; 
   d="scan'208";a="180483809"
Date: Wed, 8 Oct 2014 14:03:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/2] introduce GNTTABOP_cache_flush
Message-ID: <alpine.DEB.2.02.1410081400520.17038@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces support for GNTTABOP_cache_flush to perform
cache maintenance operation on foreign pages and reverts the current
code based on XENFEAT_grant_map_identity.


Changes in v3:
- fix the cache maintenance op call to match what Linux does natively;
- update the hypercall interface to match Xen.

Changes in v2:
- remove the definition of XENFEAT_grant_map_identity;
- update the hypercall interface to match Xen;
- call the interface on a single page at a time.


Stefano Stabellini (2):
      xen/arm: remove handling of XENFEAT_grant_map_identity
      xen/arm: introduce GNTTABOP_cache_flush

 arch/arm/xen/enlighten.c            |    5 --
 arch/arm/xen/mm32.c                 |  108 +++++++----------------------------
 include/xen/interface/features.h    |    3 -
 include/xen/interface/grant_table.h |   19 ++++++
 4 files changed, 41 insertions(+), 94 deletions(-)
