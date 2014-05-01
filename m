Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEASia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:38:30 -0400
Received: from mout.gmx.net ([212.227.15.15]:51673 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaEASi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:38:29 -0400
Date: Thu, 1 May 2014 20:38:22 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.15
Message-ID: <20140501183822.GA24823@p100.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:WmzhSEDc2yu7DJS5K4ONhWI0AblS/5Cy4tVNnY38Yn1ZcUUOvXU
 DVROaw2W3c6F3poYLIne0W07kykTn30ZgqX9Vh1TqY71hBL4DHbKLWsw4iMZPn6PiTeqFUJ
 T2OdPxLtNekveDu2wPFyP4qJpDTkEDF+JJWq5A2+73UJQA45fskTpDkTrHqshuUuf7E2PnR
 ne4rJclXuPk3/8UNV1yzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc architecture fixes for kernel 3.15 from: 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.15-2

There are two fixes in this patchset:
- Drop the architecture-specifc value for_STK_LIM_MAX to fix stack related
  problems with GNU make.
- Make mmap() behave similiar to other architectures: If a file hasn't been
  mapped yet, we can now map it at any given page-aligned address.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (2):
      parisc: Use generic uapi/asm/resource.h file
      mm,parisc: keep track of last mmap'ed address

John David Anglin (1):
      parisc: remove _STK_LIM_MAX override

 arch/parisc/Kconfig                     | 3 +++
 arch/parisc/include/uapi/asm/Kbuild     | 3 ++-
 arch/parisc/include/uapi/asm/resource.h | 7 -------
 arch/parisc/kernel/sys_parisc.c         | 8 ++++----
 include/linux/fs.h                      | 3 +++
 mm/mmap.c                               | 7 ++++++-
 6 files changed, 18 insertions(+), 13 deletions(-)
 delete mode 100644 arch/parisc/include/uapi/asm/resource.h
