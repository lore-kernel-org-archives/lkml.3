Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047AbaFTQhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:37:06 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61017 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaFTQhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:37:03 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Mark Salter <msalter@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER
In-Reply-To: <1403279282.755.23.camel@deneb.redhat.com>
Organization: http://mina86.com/
References: <1402522435-13884-1-git-send-email-msalter@redhat.com> <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com> <xa1t61jzwfo6.fsf@mina86.com> <1403201524.32688.62.camel@deneb.redhat.com> <xa1td2e41xs2.fsf@mina86.com> <1403279282.755.23.camel@deneb.redhat.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140620:rientjes@google.com::rymIU0eV6yJ+R1gF:0000000000000000000000000000000000000000000Bs9
X-Hashcash: 1:20:140620:catalin.marinas@arm.com::BDw9imfg9QAieLzK:000000000000000000000000000000000000000cCi
X-Hashcash: 1:20:140620:msalter@redhat.com::o6oGeWRGnGGWFCHl:00000000000000000000000000000000000000000001YEm
X-Hashcash: 1:20:140620:linux-arm-kernel@lists.infradead.org::gCVAg7/KDrP9JzrC:000000000000000000000000032qX
X-Hashcash: 1:20:140620:m.szyprowski@samsung.com::a9QjjJ+lH1dPO+g8:00000000000000000000000000000000000003vgy
X-Hashcash: 1:20:140620:linux-kernel@vger.kernel.org::EB9kPg2uu9vPLvIj:000000000000000000000000000000000A9ao
Date: Fri, 20 Jun 2014 18:36:55 +0200
Message-ID: <xa1tha3fv8pk.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20 2014, Mark Salter <msalter@redhat.com> wrote:
> This still isn't quite right. __free_pages can only take up to
> MAX_ORDER-1 (MAX_ORDER_NR_PAGES is 1 << (MAX_ORDER - 1)).

Good catch.  I'll send v3 in a few days then.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
