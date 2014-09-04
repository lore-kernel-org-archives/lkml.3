Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaIDMnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:43:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaIDMjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:39:09 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 0/3] xen: remove memory limits from pv-domains
Date: Thu,  4 Sep 2014 14:38:43 +0200
Message-Id: <1409834326-29287-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a Xen pv-domain is booted the initial memory map contains multiple
objects in the top 2 GB including the initrd and the p2m list. This
limits the supported maximum size of the initrd and the maximum
initial memory size is limited to about 500 GB.

Xen however supports loading the initrd without mapping it and the
initial p2m list can be mapped by Xen to an arbitrary selected virtual
address. The following patches activate those options and thus remove
the limitations.

Juergen Gross (3):
  xen: sync some headers with xen tree
  xen: eliminate scalability issues from initrd handling
  xen: eliminate scalability issues from initial mapping setup

 arch/x86/xen/enlighten.c        |  15 ++-
 arch/x86/xen/mmu.c              | 116 +++++++++++++++--
 arch/x86/xen/setup.c            |  65 +++++-----
 arch/x86/xen/xen-head.S         |   5 +
 include/xen/interface/elfnote.h | 102 ++++++++++++++-
 include/xen/interface/xen.h     | 272 ++++++++++++++++++++++++++++++++++++----
 6 files changed, 512 insertions(+), 63 deletions(-)

-- 
1.8.4.5

