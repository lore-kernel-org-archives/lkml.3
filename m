Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJBKIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:08:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12035 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBKIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:08:54 -0400
X-IronPort-AV: E=Sophos;i="5.04,638,1406592000"; 
   d="scan'208";a="178471364"
Date: Thu, 2 Oct 2014 11:06:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/2] introduce XENMEM_cache_flush
Message-ID: <alpine.DEB.2.02.1410021102480.17038@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces support for XENMEM_cache_flush to perform
cache maintenance operation on foreign pages and reverts the current
code based on XENFEAT_grant_map_identity.


Stefano Stabellini (2):
      xen/arm: remove handling of XENFEAT_grant_map_identity
      xen/arm: introduce XENMEM_cache_flush

 arch/arm/xen/enlighten.c       |    5 --
 arch/arm/xen/mm32.c            |  100 +++++++---------------------------------
 include/xen/interface/memory.h |   16 +++++++
 3 files changed, 33 insertions(+), 88 deletions(-)
