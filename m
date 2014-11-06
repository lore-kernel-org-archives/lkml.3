Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKFMbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:31:21 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41897 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKFMbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:31:18 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Weijie Yang <weijie.yang@samsung.com>, kamezawa.hiroyu@jp.fujitsu.com,
        "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 1/2] mm: page_isolation: check pfn validity before access
In-Reply-To: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
Organization: http://mina86.com/
References: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141106:weijie.yang@samsung.com::XDHkJfDf6n/UWEDO:0000000000000000000000000000000000000016P2
X-Hashcash: 1:20:141106:weijie.yang.kh@gmail.com::VFmz2vJTLV2Ph77u:00000000000000000000000000000000000001oam
X-Hashcash: 1:20:141106:linux-mm@kvack.org::OAOkzG7yY0hRhAl5:00000000000000000000000000000000000000000001liM
X-Hashcash: 1:20:141106:mgorman@suse.de::iMwSC9QjsmAdjTnf:001cJj
X-Hashcash: 1:20:141106:kamezawa.hiroyu@jp.fujitsu.com::Nf2cQk4zEZdwJsnG:00000000000000000000000000000003N/C
X-Hashcash: 1:20:141106:linux-kernel@vger.kernel.org::bpUA8DTMH/qq401i:0000000000000000000000000000000005G+F
X-Hashcash: 1:20:141106:minchan@kernel.org::qLA0xdK/VmlrjpAL:000000000000000000000000000000000000000000087rb
X-Hashcash: 1:20:141106:akpm@linux-foundation.org::sDsDQ3SfvZQFT3Ow:0000000000000000000000000000000000008am+
Date: Thu, 06 Nov 2014 13:31:14 +0100
Message-ID: <xa1ta944ik8d.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06 2014, Weijie Yang <weijie.yang@samsung.com> wrote:
> In the undo path of start_isolate_page_range(), we need to check
> the pfn validity before access its page, or it will trigger an
> addressing exception if there is hole in the zone.
>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/page_isolation.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index d1473b2..3ddc8b3 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -137,8 +137,11 @@ int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
>  undo:
>  	for (pfn = start_pfn;
>  	     pfn < undo_pfn;
> -	     pfn += pageblock_nr_pages)
> -		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
> +	     pfn += pageblock_nr_pages) {
> +		page = __first_valid_page(pfn, pageblock_nr_pages);
> +		if (page)
> +			unset_migratetype_isolate(page, migratetype);
> +	}
>  
>  	return -EBUSY;
>  }
> -- 
> 1.7.0.4
>
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
