Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaJXQey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:34:54 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:35210 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaJXQew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:34:52 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 1/4] mm: cma: Don't crash on allocation if CMA area can't be activated
In-Reply-To: <1463193.4qGZjcvNod@avalon>
Organization: http://mina86.com/
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414074828-4488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <xa1tmw8mlobz.fsf@mina86.com> <1463193.4qGZjcvNod@avalon>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141024:linux-mm@kvack.org::uyvBoO8okx38Rge7:000000000000000000000000000000000000000000005xn
X-Hashcash: 1:20:141024:linux-arm-kernel@lists.infradead.org::U1IthKglKwHs13+b:00000000000000000000000000kTG
X-Hashcash: 1:20:141024:linux@arm.linux.org.uk::qzvvM2oJu6ulf8UH:0000000000000000000000000000000000000000xWQ
X-Hashcash: 1:20:141024:laurent.pinchart@ideasonboard.com::XsvJ0q7hOFcSYJHq:00000000000000000000000000002q4X
X-Hashcash: 1:20:141024:laurent.pinchart@ideasonboard.com::zDaQMAFvXvfa6n0A:00000000000000000000000000004SO1
X-Hashcash: 1:20:141024:linux-kernel@vger.kernel.org::Cu6mqpF3pOAB1dfv:0000000000000000000000000000000003zzc
X-Hashcash: 1:20:141024:iamjoonsoo.kim@lge.com::yQMDEeFZwd8CX0oY:0000000000000000000000000000000000000006Bnx
X-Hashcash: 1:20:141024:linux-sh@vger.kernel.org::K9ar/sSG8VPnVdxQ:00000000000000000000000000000000000006vDt
X-Hashcash: 1:20:141024:m.szyprowski@samsung.com::dcXEOGFrRI7UEYRe:00000000000000000000000000000000000008qDp
Date: Fri, 24 Oct 2014 18:34:46 +0200
Message-ID: <xa1tfved2zq1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday 23 October 2014 18:53:36 Michal Nazarewicz wrote:
>> As a matter of fact, this is present in kernels earlier than 3.17 but in
>> the 3.17 the code has been moved from drivers/base/dma-contiguous.c to
>> mm/cma.c so this might require separate stable patch.

On Fri, Oct 24 2014, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> That could be done, but I'm not sure if it's really worth it. The bug only 
> occurs when the CMA zone activation fails. I've ran into that case due to a 
> bug introduced in v3.18-rc1, but this shouldn't be the case for older kernel 
> versions.

Fair enough.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
