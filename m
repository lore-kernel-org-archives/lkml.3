Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbaEaADA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:03:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40322 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaEaAC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:02:58 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Gioh Kim <gioh.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma reserved memory when not used
In-Reply-To: <20140530004514.GB8906@js1304-P5Q-DELUXE>
Organization: http://mina86.com/
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com> <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com> <5386E0CA.5040201@lge.com> <20140529074847.GA7554@js1304-P5Q-DELUXE> <5386EB3E.5090007@lge.com> <20140530004514.GB8906@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140531:linux-mm@kvack.org::/4DuE1QZJ+EtF8/B:00000000000000000000000000000000000000000001KXR
X-Hashcash: 1:20:140531:aneesh.kumar@linux.vnet.ibm.com::nCMPduBP5eQYe67B:0000000000000000000000000000002dEg
X-Hashcash: 1:20:140531:hannes@cmpxchg.org::vCnWUY91SyV8ytkv:00000000000000000000000000000000000000000001jZe
X-Hashcash: 1:20:140531:akpm@linux-foundation.org::0ruqc5pWyargdFyq:0000000000000000000000000000000000002YnP
X-Hashcash: 1:20:140531:riel@redhat.com::mvBlHuY9TLHZGvXC:002weQ
X-Hashcash: 1:20:140531:mgorman@suse.de::B9ovEfFLmSbeRy3J:002fO7
X-Hashcash: 1:20:140531:m.szyprowski@samsung.com::ti5VTQaTe7Psk/JQ:000000000000000000000000000000000000049Fp
X-Hashcash: 1:20:140531:linux-kernel@vger.kernel.org::mKHDNCBiWvTECiXt:0000000000000000000000000000000004ipL
X-Hashcash: 1:20:140531:lauraa@codeaurora.org::aTxF0jOVOkRmmkPC:00000000000000000000000000000000000000003iGj
X-Hashcash: 1:20:140531:gioh.kim@lge.com::GvqyI/qHQPDrhd7B:05fZT
X-Hashcash: 1:20:140531:minchan@kernel.org::t+vJahvE/yPi70Fh:00000000000000000000000000000000000000000005bUt
X-Hashcash: 1:20:140531:iamjoonsoo.kim@lge.com::dSMN/URlMRN5olcb:0000000000000000000000000000000000000006cht
X-Hashcash: 1:20:140531:heesub.shin@samsung.com::iOa+e46USEnIAWJm:00000000000000000000000000000000000000GtPT
Date: Sat, 31 May 2014 09:02:51 +0900
Message-ID: <xa1tha46hl1w.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 29, 2014 at 05:09:34PM +0900, Gioh Kim wrote:
>> Is IS_ENABLED(CONFIG_CMA) necessary?
>> What about if (migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages) ?

On Fri, May 30 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Yes, field, managed_cma_pages exists only if CONFIG_CMA is enabled, so
> removing IS_ENABLE(CONFIG_CMA) would break the build.

That statement makes no sense.  If zone->managed_cma_pages not being
defined is the problem, what you need is:

+#ifdef CONFIG_CMA
+	if (migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages)
+		page = __rmqueue_cma(zone, order);
+#endif

If you use IS_ENABLED, zone-managed_cma_pages has to be defined
regardless of result of state of CONFIG_CMA.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
