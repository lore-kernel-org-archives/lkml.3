Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaGDKNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:13:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbaGDKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:13:09 -0400
Date: Fri, 4 Jul 2014 03:12:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
        Christoph Hellwig <hch@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: introduce fincore()
Message-ID: <20140704101230.GA24688@infradead.org>
References: <1404424335-30128-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404424335-30128-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404424335-30128-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 05:52:13PM -0400, Naoya Horiguchi wrote:
> This patch provides a new system call fincore(2), which provides mincore()-
> like information, i.e. page residency of a given file. But unlike mincore(),
> fincore() has a mode flag which allows us to extract detailed information
> about page cache like pfn and page flag. This kind of information is very
> helpful, for example when applications want to know the file cache status
> to control the IO on their own way.

It's still a nasty multiplexer for multiple different reporting formats
in a single system call.  How about your really just do a fincore that
mirrors mincore instead of piggybacking exports of various internal
flags (tags and page flags onto it.

