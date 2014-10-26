Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaJZMnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:43:53 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46452 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaJZMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:43:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Weijie Yang <weijie.yang.kh@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] mm: cma: Ensure that reservations never cross the low/high mem boundary
Date: Sun, 26 Oct 2014 14:43:52 +0200
Message-ID: <1436531.s0VJY8ZaKv@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <xa1toat13031.fsf@mina86.com>
References: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414145922-26042-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <xa1toat13031.fsf@mina86.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2014 18:26:58 Michal Nazarewicz wrote:
> On Fri, Oct 24 2014, Laurent Pinchart wrote:
> > Commit 95b0e655f914 ("ARM: mm: don't limit default CMA region only to
> > low memory") extended CMA memory reservation to allow usage of high
> > memory. It relied on commit f7426b983a6a ("mm: cma: adjust address limit
> > to avoid hitting low/high memory boundary") to ensure that the reserved
> > block never crossed the low/high memory boundary. While the
> > implementation correctly lowered the limit, it failed to consider the
> > case where the base..limit range crossed the low/high memory boundary
> > with enough space on each side to reserve the requested size on either
> > low or high memory.
> > 
> > Rework the base and limit adjustment to fix the problem. The function
> > now starts by rejecting the reservation altogether for fixed
> > reservations that cross the boundary, tries to reserve from high memory
> > first and then falls back to low memory.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thank you. Can we get this series merged in v3.18-rc ?

-- 
Regards,

Laurent Pinchart

