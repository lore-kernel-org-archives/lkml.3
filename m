Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaJ1Mia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:38:30 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33696 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaJ1Mi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:38:26 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: CMA: test_pages_isolated failures in alloc_contig_range
In-Reply-To: <2457604.k03RC2Mv4q@avalon>
Organization: http://mina86.com/
References: <2457604.k03RC2Mv4q@avalon>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141028:linux-sh@vger.kernel.org::pDuiFmoOa3VJMMvf:00000000000000000000000000000000000000fEI
X-Hashcash: 1:20:141028:b.zolnierkie@samsung.com::YgtxzwGAkSFJgnvJ:00000000000000000000000000000000000001YXf
X-Hashcash: 1:20:141028:minchan@kernel.org::62o6pcwLLVERRus6:00000000000000000000000000000000000000000001uZ8
X-Hashcash: 1:20:141028:linux-mm@kvack.org::kmcGm0DNZrjSfsGb:000000000000000000000000000000000000000000026Cb
X-Hashcash: 1:20:141028:linux-kernel@vger.kernel.org::QQliqYdS5fXYuEiZ:0000000000000000000000000000000003bY2
X-Hashcash: 1:20:141028:laurent.pinchart@ideasonboard.com::HMY3KzmGweEM5QIj:00000000000000000000000000004s1+
Date: Tue, 28 Oct 2014 13:38:20 +0100
Message-ID: <xa1tsii8l683.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26 2014, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> Hello,
>
> I've run into a CMA-related issue while testing a DMA engine driver with 
> dmatest on a Renesas R-Car ARM platform. 
>
> When allocating contiguous memory through CMA the kernel prints the following 
> messages to the kernel log.
>
> [   99.770000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
> [  124.220000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
> [  127.550000] alloc_contig_range test_pages_isolated(6b845, 6b846) failed
> [  132.850000] alloc_contig_range test_pages_isolated(6b845, 6b846) failed
> [  151.390000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
> [  166.490000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
> [  181.450000] alloc_contig_range test_pages_isolated(6b845, 6b846) failed
>
> I've stripped the dmatest module down as much as possible to remove any 
> hardware dependencies and came up with the following implementation.

Like Laura wrote, the message is not (should not be) a problem in
itself:

mm/page_alloc.c:

int alloc_contig_range(unsigned long start, unsigned long end,
		       unsigned migratetype)
{
	[…]
	/* Make sure the range is really isolated. */
	if (test_pages_isolated(outer_start, end, false)) {
		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
		       outer_start, end);
		ret = -EBUSY;
		goto done;
	}
	[…]
done:
	undo_isolate_page_range(pfn_max_align_down(start),
				pfn_max_align_up(end), migratetype);
	return ret;
}

mm/cma.c:

struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
{
	[…]
	for (;;) {
		bitmap_no = bitmap_find_next_zero_area(cma->bitmap,
				bitmap_maxno, start, bitmap_count, mask);
		if (bitmap_no >= bitmap_maxno)
			break;
		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);

		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
		if (ret == 0) {
			page = pfn_to_page(pfn);
			break;
		}

		cma_clear_bitmap(cma, pfn, count);
		if (ret != -EBUSY)
			break;

		pr_debug("%s(): memory range at %p is busy, retrying\n",
			 __func__, pfn_to_page(pfn));
		/* try again with a bit different memory target */
		start = bitmap_no + mask + 1;
	}
	[…]
}

So as you can see cma_alloc will try another part of the cma region if
test_pages_isolated fails.

Obviously, if CMA region is fragmented or there's enough space for only
one allocation of required size isolation failures will cause allocation
failures, so it's best to avoid them, but they are not always avoidable.

To debug you would probably want to add more debug information about the
page (i.e. data from struct page) that failed isolation after the
pr_warn in alloc_contig_range.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
