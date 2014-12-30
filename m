Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaL3OlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:41:13 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64093 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaL3OlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:41:11 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Stefan I. Strogin" <s.strogin@partner.samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 3/3] cma: add functions to get region pages counters
In-Reply-To: <20141230022625.GA4588@js1304-P5Q-DELUXE>
Organization: http://mina86.com/
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com> <20141230022625.GA4588@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141230:v.tyrtov@samsung.com::dZvOmwdW9OtowQ57:000000000000000000000000000000000000000000L5J
X-Hashcash: 1:20:141230:laurent.pinchart@ideasonboard.com::B3MAwyb2qh6wZT+c:00000000000000000000000000000DcG
X-Hashcash: 1:20:141230:m.szyprowski@samsung.com::Mjt95rt6d9kFsLzO:00000000000000000000000000000000000000XZf
X-Hashcash: 1:20:141230:minchan@kernel.org::4jREbYJvbGyXMrbX:00000000000000000000000000000000000000000000Oq3
X-Hashcash: 1:20:141230:lauraa@codeaurora.org::qzYX90cXL+Li6FYO:00000000000000000000000000000000000000000miT
X-Hashcash: 1:20:141230:linux-kernel@vger.kernel.org::425sJt+woq+lYUUk:0000000000000000000000000000000001IqF
X-Hashcash: 1:20:141230:s.dyasly@samsung.com::JEnAmA9BcEAG/nrA:000000000000000000000000000000000000000002AsC
X-Hashcash: 1:20:141230:s.strogin@partner.samsung.com::KItPwCmK7I/gzXGn:000000000000000000000000000000002lGY
X-Hashcash: 1:20:141230:iamjoonsoo.kim@lge.com::sZbdR8P+DqJOKKFT:0000000000000000000000000000000000000003eHs
X-Hashcash: 1:20:141230:weijie.yang@samsung.com::VHKqK2X+bUztaijk:0000000000000000000000000000000000000048ly
X-Hashcash: 1:20:141230:akpm@linux-foundation.org::sEGA+IvtLZ5fRX9O:00000000000000000000000000000000000078FG
X-Hashcash: 1:20:141230:linux-mm@kvack.org::5RBLj3WgxocUo/d8:00000000000000000000000000000000000000000007ubR
X-Hashcash: 1:20:141230:sj38.park@gmail.com::EjLsPOReUI1Ns/9B:0000000000000000000000000000000000000000006gCp
X-Hashcash: 1:20:141230:pintu.k@samsung.com::91P5r13esV0f3lvL:0000000000000000000000000000000000000000006l6k
X-Hashcash: 1:20:141230:aneesh.kumar@linux.vnet.ibm.com::wMoFSivk6yGzGRGT:0000000000000000000000000000006ZXE
X-Hashcash: 1:20:141230:d.safonov@partner.samsung.com::SAUXsVRPgbEXHGfS:000000000000000000000000000000007YNq
X-Hashcash: 1:20:141230:zhuhui@xiaomi.com::S49zhFEat9Fv14gq:0000000000000000000000000000000000000000000088SY
Date: Tue, 30 Dec 2014 15:41:05 +0100
Message-ID: <xa1th9wdtd32.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Dec 26, 2014 at 05:39:04PM +0300, Stefan I. Strogin wrote:
>> From: Dmitry Safonov <d.safonov@partner.samsung.com>
>> @@ -591,6 +621,10 @@ static int s_show(struct seq_file *m, void *p)
>>  	struct cma_buffer *cmabuf;
>>  	struct stack_trace trace;
>>  
>> +	seq_printf(m, "CMARegion stat: %8lu kB total, %8lu kB used, %8lu kB max contiguous chunk\n\n",
>> +		   cma_get_size(cma) >> 10,
>> +		   cma_get_used(cma) >> 10,
>> +		   cma_get_maxchunk(cma) >> 10);
>>  	mutex_lock(&cma->list_lock);
>>  
>>  	list_for_each_entry(cmabuf, &cma->buffers_list, list) {

On Tue, Dec 30 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> How about changing printing format like as meminfo or zoneinfo?
>
> CMARegion #
> Total: XXX
> Used: YYY
> MaxContig: ZZZ

+1.  I was also thinking about this actually.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
