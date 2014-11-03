Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaKCQpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:45:42 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:47251 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCQph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:45:37 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Florian Fainelli <f.fainelli@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lauraa@codeaurora.org, gioh.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DMA allocations from CMA and fatal_signal_pending check
In-Reply-To: <5453F80C.4090006@gmail.com>
Organization: http://mina86.com/
References: <544FE9BE.6040503@gmail.com> <20141031082818.GB14642@js1304-P5Q-DELUXE> <5453F80C.4090006@gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141103:m.szyprowski@samsung.com::HAZl7dBUSdBHcgqS:00000000000000000000000000000000000000Dks
X-Hashcash: 1:20:141103:gioh.kim@lge.com::79wliBcklzcA9iHi:00ABd
X-Hashcash: 1:20:141103:linux-arm-kernel@lists.infradead.org::1KiVJIWucKPxl3E4:00000000000000000000000001H6e
X-Hashcash: 1:20:141103:linux-mm@kvack.org::c1CX9uzxyJlp/wm0:00000000000000000000000000000000000000000001fii
X-Hashcash: 1:20:141103:gregory.0xf0@gmail.com::v4Ur2KIs5OCDdxmz:0000000000000000000000000000000000000002L1p
X-Hashcash: 1:20:141103:linux-kernel@vger.kernel.org::NLLXBWzKjLsKXDPS:0000000000000000000000000000000002dNv
X-Hashcash: 1:20:141103:akpm@linux-foundation.org::NjYw1tUdYDgGchhP:0000000000000000000000000000000000003nwx
X-Hashcash: 1:20:141103:f.fainelli@gmail.com::Qhh4Lh2y+Kfhw0iO:000000000000000000000000000000000000000005Ma9
X-Hashcash: 1:20:141103:aneesh.kumar@linux.vnet.ibm.com::cwU7SdlBWKUgI9SU:0000000000000000000000000000006Ccp
X-Hashcash: 1:20:141103:iamjoonsoo.kim@lge.com::LQ0rwUDrFL2ivKoH:0000000000000000000000000000000000000006DFX
X-Hashcash: 1:20:141103:netdev@vger.kernel.org::isyoZfBkgaA1VqiV:0000000000000000000000000000000000000006R6d
X-Hashcash: 1:20:141103:lauraa@codeaurora.org::fNW6CCxRMZL25a4f:00000000000000000000000000000000000000007GEm
X-Hashcash: 1:20:141103:computersforpeace@gmail.com::zLB2IHogEbcwKhe+:00000000000000000000000000000000009Gy4
Date: Mon, 03 Nov 2014 17:45:31 +0100
Message-ID: <xa1tlhnsw7v8.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31 2014, Florian Fainelli wrote:
> I agree that the CMA allocation should not be allowed to succeed, but
> the dma_alloc_coherent() allocation should succeed. If we look at the
> sysport driver, there are kmalloc() calls to initialize private
> structures, those will succeed (except under high memory pressure), so
> by the same token, a driver expects DMA allocations to succeed (unless
> we are under high memory pressure)
>
> What are we trying to solve exactly with the fatal_signal_pending()
> check here? Are we just optimizing for the case where a process has
> allocated from a CMA region to allow this region to be returned to the
> pool of free pages when it gets killed? Could there be another mechanism
> used to reclaim those pages if we know the process is getting killed
> anyway?

We're guarding against situations where process may hang around
arbitrarily long time after receiving SIGKILL.  If user does “kill -9
$pid” the usual expectation is that the $pid process will die within
seconds and anything longer is perceived by user as a bug.

What problem are *you* trying to solve?  If user sent SIGKILL to
a process that imitated device initialisation, what is the point of
continuing initialising the device?  Just recover and return -EINTR.

> Well, not really. This driver is not an isolated case, there are tons of
> other networking drivers that do exactly the same thing, and we do
> expect these dma_alloc_* calls to succeed.

Again, why do you expect them to succeed?  The code must handle failures
correctly anyway so why do you wish to ignore fatal signal?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
