Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaKDW1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:27:36 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43763 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKDW1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:27:34 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org
Cc: lauraa@codeaurora.org, iamjoonsoo.kim@lge.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: CMA alignment question
In-Reply-To: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com>
Organization: http://mina86.com/
References: <CADtm3G7DtGkvPk36Fiunwen8grw-94V6=iv82iusGumfNJkn-g@mail.gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141104:iamjoonsoo.kim@lge.com::BPGfe5rE5kUtV8Bj:0000000000000000000000000000000000000000ngv
X-Hashcash: 1:20:141104:linux-mm@kvack.org::oB5o6qqVPeY5k4HV:00000000000000000000000000000000000000000003xPv
X-Hashcash: 1:20:141104:computersforpeace@gmail.com::Tx/Eh74hPov1GCkL:00000000000000000000000000000000004+HV
X-Hashcash: 1:20:141104:lauraa@codeaurora.org::GDEUONSrWwJPRv8G:00000000000000000000000000000000000000005l8x
X-Hashcash: 1:20:141104:m.szyprowski@samsung.com::r0Rbz4lp7d16q8RJ:00000000000000000000000000000000000006x5i
X-Hashcash: 1:20:141104:linux-kernel@vger.kernel.org::CH9WoD2DLy36iJl7:0000000000000000000000000000000007OZq
X-Hashcash: 1:20:141104:f.fainelli@gmail.com::+FQkceNmONG0Qpam:000000000000000000000000000000000000000008K9e
X-Hashcash: 1:20:141104:gregory.0xf0@gmail.com::l5kX1aBpiAtQhxyQ:000000000000000000000000000000000000000Cv63
Date: Tue, 04 Nov 2014 23:27:28 +0100
Message-ID: <xa1tlhnq7ga7.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04 2014, Gregory Fong wrote:
> The alignment in cma_alloc() is done w.r.t. the bitmap.  This is a
> problem when, for example:
>
> - a device requires 16M (order 12) alignment
> - the CMA region is not 16 M aligned
>
> In such a case, can result with the CMA region starting at, say,
> 0x2f800000 but any allocation you make from there will be aligned from
> there.  Requesting an allocation of 32 M with 16 M alignment, will
> result in an allocation from 0x2f800000 to 0x31800000, which doesn't
> work very well if your strange device requires 16M alignment.
>
> This doesn't have the behavior I would expect, which would be for the
> allocation to be aligned w.r.t. the start of memory.  I realize that
> aligning the CMA region is an option, but don't see why cma_alloc()
> aligns to the start of the CMA region.  Is there a good reason for
> having cma_alloc() alignment work this way?

No, it's a bug.  The alignment should indicate alignment of physical
address not position in CMA region.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
