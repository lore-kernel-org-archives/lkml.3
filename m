Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbaGDRnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbaGDRnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:43:15 -0400
Date: Fri, 4 Jul 2014 12:31:07 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: =?iso-8859-1?Q?C=E9dric?= Villemain <cedric@2ndquadrant.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: introduce fincore()
Message-ID: <20140704163107.GA17877@nhori>
References: <1404424335-30128-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404424335-30128-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140704101230.GA24688@infradead.org>
 <5816450.BPnLjGgtl5@obelix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5816450.BPnLjGgtl5@obelix>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 05:15:59PM +0200, Cédric Villemain wrote:
> Le vendredi 4 juillet 2014 03:12:30 Christoph Hellwig a écrit :
> > On Thu, Jul 03, 2014 at 05:52:13PM -0400, Naoya Horiguchi wrote:
> > > This patch provides a new system call fincore(2), which provides
> > > mincore()- like information, i.e. page residency of a given file.
> > > But unlike mincore(), fincore() has a mode flag which allows us to
> > > extract detailed information about page cache like pfn and page
> > > flag. This kind of information is very helpful, for example when
> > > applications want to know the file cache status to control the IO
> > > on their own way.
> > 
> > It's still a nasty multiplexer for multiple different reporting
> > formats in a single system call.  How about your really just do a
> > fincore that mirrors mincore instead of piggybacking exports of
> > various internal flags (tags and page flags onto it.

We can do it in mincore-compatible way with FINCORE_BMAP mode.
If you choose it, you don't care about any details about other modes.
I don't make no default mode, but if we have a good reason, I'm OK
to set FINCORE_BMAP as default mode.

> The fincore à la mincore got some arguments against it too. It seems this 
> implementations try (I've not tested nor have a close look yet) to 
> answer both concerns : have details and also possible to have 
> aggregation function not too expansive.

Correct, that's the motivation of this non-trivial interface.
This could finally obsoletes messy /proc/kpage{flags,count} and/or
/proc/pid/pagemap kind of things, and we will not have to collect
information over all these interfaces (so that's less expensive.)

Thanks,
Naoya Horiguchi
