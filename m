Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaJWOd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:33:58 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43906 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaJWOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:33:55 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/4] Low/high memory CMA reservation fixes
Date: Thu, 23 Oct 2014 17:33:44 +0300
Message-Id: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set fixes an issue introduced by commits 95b0e655f914 ("ARM: mm:
don't limit default CMA region only to low memory") and f7426b983a6a ("mm:
cma: adjust address limit to avoid hitting low/high memory boundary")
resulting in reserved areas crossing the low/high memory boundary.

Patches 1/4 and 2/4 fix sides issues, with the bulk of the work in patch 3/4.
Patch 4/4 then fixes a printk issue that got me puzzled wondering why memory
reported under the lowmem limit was actually highmem.

This series fixes a v3.18-rc1 regression causing Renesas Koelsch boot
breakages when CMA is enabled.

Laurent Pinchart (4):
  mm: cma: Don't crash on allocation if CMA area can't be activated
  mm: cma: Always consider a 0 base address reservation as dynamic
  mm: cma: Ensure that reservations never cross the low/high mem
    boundary
  mm: cma: Use %pa to print physical addresses

 mm/cma.c | 93 +++++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 33 deletions(-)

-- 
Regards,

Laurent Pinchart

