Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbbALFFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 00:05:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbbALFFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 00:05:17 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [Patch V2 0/4] xen: correct several bugs in new p2m list setup
Date: Mon, 12 Jan 2015 06:05:06 +0100
Message-Id: <1421039110-11207-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the setup code of the linear mapped p2m list several bugs have
been found, especially for 32 bit dom0. These patches correct the
errors and make 32 bit dom0 bootable again.

Changes since V1:
- split up patch 3 as requested by David Vrabel
- use phys_addr_t instead of u64 as requested by Jan Beulich
- compare pfns instead physical addresses as suggested by Jan Beulich

Juergen Gross (4):
  xen: correct error for building p2m list on 32 bits
  xen: correct race in alloc_p2m_pmd()
  xen: use correct type for physical addresses
  xen: check for zero sized area when invalidating memory

 arch/x86/xen/p2m.c   | 11 ++++-------
 arch/x86/xen/setup.c |  6 ++++--
 2 files changed, 8 insertions(+), 9 deletions(-)

-- 
2.1.2

