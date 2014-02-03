Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaBCDAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 22:00:14 -0500
Received: from ozlabs.org ([203.10.76.45]:59209 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaBCDAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 22:00:12 -0500
Message-ID: <1391396405.30409.6.camel@concordia>
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Michael Ellerman <mpe@ellerman.id.au>
To: Alistair Popple <alistair@popple.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Olaf Hering <olaf@aepfle.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 03 Feb 2014 14:00:05 +1100
In-Reply-To: <4555187.D5eRSF5r8x@mexican>
References: <1390883744.3872.76.camel@pasglop>
	 <20140128150309.GA7428@aepfle.de> <1390940395.8524.25.camel@pasglop>
	 <4555187.D5eRSF5r8x@mexican>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 13:29 +1100, Alistair Popple wrote:
> Looks like I missed the dart iommu code when changing the iommu table
> initialisation. The patch below should fix it, would you mind testing
> it Ben? Thanks.

Any reason not to add the following to save ourselves in future?

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index d773dd4..6ab7b53 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -657,6 +657,8 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
        unsigned int i;
        struct iommu_pool *p;
 
+       BUG_ON(!tbl->it_page_shift);
+
        /* number of bytes needed for the bitmap */
        sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
 

cheers



