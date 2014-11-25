Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981AbaKYOdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:33:32 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:57624 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKYOdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:33:31 -0500
Date: Tue, 25 Nov 2014 16:32:19 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Rientjes <rientjes@google.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, sasha.levin@oracle.com,
        n-horiguchi@ah.jp.nec.com, andriy.shevchenko@linux.intel.com,
        hannes@cmpxchg.org, vdavydov@parallels.com, fabf@skynet.be,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jianyu Zhan <jianyu.zhan@emc.com>
Subject: Re: [PATCH] mm, gfp: escalatedly define GFP_HIGHUSER and
 GFP_HIGHUSER_MOVABLE
Message-ID: <20141125143219.GC11841@node.dhcp.inet.fi>
References: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
 <20141124190127.GA5027@node.dhcp.inet.fi>
 <alpine.DEB.2.10.1411241334490.21237@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411241334490.21237@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:35:00PM -0800, David Rientjes wrote:
> On Mon, 24 Nov 2014, Kirill A. Shutemov wrote:
> 
> > But I would prefer to have GPF_HIGHUSER movable by default and
> > GFP_HIGHUSER_UNMOVABLE to opt out.
> > 
> 
> Sounds like a separate patch.

There are few questions before preparing patch:

1. Compatibility: some code which is not yet in tree can rely on
non-movable behaviour of GFP_HIGHUSER. How would we handle this?
Should we invent new name for the movable GFP_HIGHUSER?

2. Should GFP_USER be movable too? And the same compatibility question
here.

3. Do we need a separate define for non-movable GPF_HIGHUSER or caller
should use something like GPF_HIGHUSER & ~__GFP_MOVABLE?

4. Is there a gain, taking into account questions above?

-- 
 Kirill A. Shutemov
