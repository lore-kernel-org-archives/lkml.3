Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaFZP55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:57:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45665 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaFZP5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:57:55 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Gioh Kim <gioh.kim@lge.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [RFC] CMA page migration failure due to buffers on bh_lru
In-Reply-To: <53A8D092.4040801@lge.com>
Organization: http://mina86.com/
References: <53A8D092.4040801@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140626:iamjoonsoo.kim@lge.com::vdXQvVFosioAoY/d:0000000000000000000000000000000000000000mso
X-Hashcash: 1:20:140626:gioh.kim@lge.com::0v2DiW5Fc1sPRJHA:01srl
X-Hashcash: 1:20:140626:linux-kernel@vger.kernel.org::FRbPAVkhN2mETh+x:00000000000000000000000000000000024bD
X-Hashcash: 1:20:140626:gunho.lee@lge.com::aLV237VTwS16dH4m:000000000000000000000000000000000000000000002YMk
X-Hashcash: 1:20:140626:linux-mm@kvack.org::k0hsDOUG8jhxAICB:00000000000000000000000000000000000000000002zDg
X-Hashcash: 1:20:140626:m.szyprowski@samsung.com::SzVHLG8v1HMqRwPH:00000000000000000000000000000000000004BcD
X-Hashcash: 1:20:140626:mgorman@suse.de::0Q3wutb8+5fEcTAF:005Ry/
Date: Thu, 26 Jun 2014 17:57:45 +0200
Message-ID: <xa1td2dvmznq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24 2014, Gioh Kim <gioh.kim@lge.com> wrote:
> Hello,
>
> I am trying to apply CMA feature for my platform.
> My kernel version, 3.10.x, is not allocating memory from CMA area so that I applied
> a Joonsoo Kim's patch (https://lkml.org/lkml/2014/5/28/64).
> Now my platform can use CMA area effectively.
>
> But I have many failures to allocate memory from CMA area.
> I found the same situation to Laura Abbott's patch descrbing,
> https://lkml.org/lkml/2012/8/31/313,
> that releases buffer-heads attached at CPU's LRU list.
>
> If Joonsoo's patch is applied and/or CMA feature is applied more and more,
> buffer-heads problem is going to be serious definitely.
>
> Please look into the Laura's patch again.
> I think it must be applied with Joonsoo's patch.

Just to make sure I understood you correctly, you're saying Laura's
patch at <https://lkml.org/lkml/2012/8/31/313> fixes your issue?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
