Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3E0IjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:39:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63553 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3E0IjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:39:17 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 04:39:17 EDT
X-AuditID: 9c93017d-b7b64ae000000e51-98-51a3182d5e24
Date: Mon, 27 May 2013 17:24:13 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minkyung Kim <minkyung88@lge.com>
Subject: Re: [PATCH v5 6/7] mm: Support address range reclaim
Message-ID: <20130527082413.GC5157@blaptop>
References: <1368084089-24576-1-git-send-email-minchan@kernel.org>
 <1368084089-24576-7-git-send-email-minchan@kernel.org>
 <20130521173332.637942da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521173332.637942da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 05:33:32PM -0700, Andrew Morton wrote:
> On Thu,  9 May 2013 16:21:28 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > This patch adds address range reclaim of a process.
> > The requirement is following as,
> > 
> > Like webkit1, it uses a address space for handling multi tabs.
> > IOW, it uses *one* process model so all tabs shares address space
> > of the process. In such scenario, per-process reclaim is rather
> > coarse-grained so this patch supports more fine-grained reclaim
> > for being able to reclaim target address range of the process.
> > For reclaim target range, you should use following format.
> > 
> > 	echo [addr] [size-byte] > /proc/pid/reclaim
> > 
> > The addr should be page-aligned.
> > 
> > So now reclaim konb's interface is following as.
> > 
> > echo file > /proc/pid/reclaim
> > 	reclaim file-backed pages only
> > 
> > echo anon > /proc/pid/reclaim
> > 	reclaim anonymous pages only
> > 
> > echo all > /proc/pid/reclaim
> > 	reclaim all pages
> > 
> > echo 0x100000 8K > /proc/pid/reclaim
> > 	reclaim pages in (0x100000 - 0x102000)
> 
> This might be going a bit far.  The application itself can be modified
> to use fadvise/madvise/whatever to release unused pages and that's a
> better interface.

I agree. The webkit should be smarter and it's going on afaik but
let's think another usecase that makes snapshot image scenario
I mentioned in previous reply.

Admin should discard NOT-IMPORTANT pages without modifying application's
code.

In addition, maybe we need madvise(MADV_SWAPOUT_NOT_DONTNEED) for
anonymous pages if we don't have such feature.

> 
> Athough it's a bit of a pipe-dream, I do think we should encourage
> userspace to go this path, rather than providing ways for hacky admin
> tools to go poking around in /proc/pid/maps and whacking apps
> externally.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
