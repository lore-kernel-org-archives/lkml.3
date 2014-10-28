Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaJ1Q5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:57:52 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41984 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaJ1Q5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:57:50 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CMA: test_pages_isolated failures in alloc_contig_range
In-Reply-To: <544F9EAA.5010404@hurleysoftware.com>
Organization: http://mina86.com/
References: <2457604.k03RC2Mv4q@avalon> <xa1tsii8l683.fsf@mina86.com> <544F9EAA.5010404@hurleysoftware.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141028:linux-mm@kvack.org::DC7M+V4GTtYgbEc3:0000000000000000000000000000000000000000000035O
X-Hashcash: 1:20:141028:linux-sh@vger.kernel.org::+dHiJeWxQ1u+5Rnl:00000000000000000000000000000000000000Dqv
X-Hashcash: 1:20:141028:laurent.pinchart@ideasonboard.com::iSvm4om1uFyTA9/Z:00000000000000000000000000000GgA
X-Hashcash: 1:20:141028:b.zolnierkie@samsung.com::yoJXhw/wogkjvjnN:00000000000000000000000000000000000000tbP
X-Hashcash: 1:20:141028:linux-kernel@vger.kernel.org::x9ZBZKk2P5pjSBkP:0000000000000000000000000000000001L9H
X-Hashcash: 1:20:141028:peter@hurleysoftware.com::FS1vAPB+d45ENuKb:00000000000000000000000000000000000001OZF
X-Hashcash: 1:20:141028:minchan@kernel.org::btY0K2z/ZEz33LBS:00000000000000000000000000000000000000000004jSI
X-Hashcash: 1:20:141028:akpm@linux-foundation.org::d9ou9KgxG+YQqA/l:0000000000000000000000000000000000007Spa
Date: Tue, 28 Oct 2014 17:57:45 +0100
Message-ID: <xa1tfve8ku7q.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 10/28/2014 08:38 AM, Michal Nazarewicz wrote:
>> Like Laura wrote, the message is not (should not be) a problem in
>> itself:
>
> [...]
>
>> So as you can see cma_alloc will try another part of the cma region if
>> test_pages_isolated fails.
>> 
>> Obviously, if CMA region is fragmented or there's enough space for only
>> one allocation of required size isolation failures will cause allocation
>> failures, so it's best to avoid them, but they are not always avoidable.
>> 
>> To debug you would probably want to add more debug information about the
>> page (i.e. data from struct page) that failed isolation after the
>> pr_warn in alloc_contig_range.

On Tue, Oct 28 2014, Peter Hurley <peter@hurleysoftware.com> wrote:
> If the message does not indicate an actual problem, then its printk level is
> too high. These messages have been reported when using 3.16+ distro kernels.

I think it could be argued both ways.  The condition is not an error,
since in many cases cma_alloc will be able to continue, but it *is* an
undesired state.  As such it's not an error but feels to me a bit more
then just information, hence a warning.  I don't care either way, though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
