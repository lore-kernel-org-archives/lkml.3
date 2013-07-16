Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab3GPOUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:20:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:38792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab3GPOUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:20:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,677,1367996400"; 
   d="scan'208";a="371171463"
Date: Tue, 16 Jul 2013 07:20:10 -0700
From: Andi Kleen <ak@linux.jf.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.jf.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.jf.intel.com>,
        h.mitake@gmail.com, kirill.shutemov@linux.jf.intel.com
Subject: Re: [PATCH] perf, tools, bench: Fix memcpy benchmark for large sizes
Message-ID: <20130716142010.GR5643@tassilo.jf.intel.com>
References: <1373675551-18684-1-git-send-email-andi@firstfloor.org>
 <20130716101100.C2A70E0090@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716101100.C2A70E0090@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -117,6 +117,8 @@ static void alloc_mem(void **dst, void **src, size_t length)
> >  	*src = zalloc(length);
> >  	if (!src)
> >  		die("memory allocation failed - maybe length is too large?\n");
> > +	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
> > +	memset(src, 0, length);
> 
> It should be memset(*src, 0, length) instead.

Thanks for catching. I wonder why it fixed the problem for me.

> There's fix for wrong memory allocation fail check in v3.11-rc1.

Doubt it matters.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
