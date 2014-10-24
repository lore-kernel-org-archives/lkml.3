Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaJXQ1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:27:08 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57939 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaJXQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:27:04 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Weijie Yang <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH v2 3/4] mm: cma: Ensure that reservations never cross the low/high mem boundary
In-Reply-To: <1414145922-26042-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organization: http://mina86.com/
References: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414145922-26042-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141024:linux-arm-kernel@lists.infradead.org::GwfKHbMRa0SYQRN1:000000000000000000000000006XA
X-Hashcash: 1:20:141024:m.szyprowski@samsung.com::uUqbbOAZs/a9Eg1N:00000000000000000000000000000000000000R8w
X-Hashcash: 1:20:141024:laurent.pinchart@ideasonboard.com::LNbV1rNWYY6QfD3a:00000000000000000000000000000YiF
X-Hashcash: 1:20:141024:iamjoonsoo.kim@lge.com::diUAFJQY0R3x2qlj:0000000000000000000000000000000000000003M1Y
X-Hashcash: 1:20:141024:linux-sh@vger.kernel.org::gCfqVHrPTiTGaymU:00000000000000000000000000000000000002iOr
X-Hashcash: 1:20:141024:linux-kernel@vger.kernel.org::34QsBwqq1JjnDQrS:0000000000000000000000000000000003T8w
X-Hashcash: 1:20:141024:linux-mm@kvack.org::Xu4o4gwzN2/QyWkb:00000000000000000000000000000000000000000005Rpg
X-Hashcash: 1:20:141024:weijie.yang.kh@gmail.com::5cnwCu+7Y+S1V6Xv:000000000000000000000000000000000000085Nl
X-Hashcash: 1:20:141024:linux@arm.linux.org.uk::FBO4fwTDPmwWezz0:000000000000000000000000000000000000000BB7a
Date: Fri, 24 Oct 2014 18:26:58 +0200
Message-ID: <xa1toat13031.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2014, Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> wrote:
> Commit 95b0e655f914 ("ARM: mm: don't limit default CMA region only to
> low memory") extended CMA memory reservation to allow usage of high
> memory. It relied on commit f7426b983a6a ("mm: cma: adjust address limit
> to avoid hitting low/high memory boundary") to ensure that the reserved
> block never crossed the low/high memory boundary. While the
> implementation correctly lowered the limit, it failed to consider the
> case where the base..limit range crossed the low/high memory boundary
> with enough space on each side to reserve the requested size on either
> low or high memory.
>
> Rework the base and limit adjustment to fix the problem. The function
> now starts by rejecting the reservation altogether for fixed
> reservations that cross the boundary, tries to reserve from high memory
> first and then falls back to low memory.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>
