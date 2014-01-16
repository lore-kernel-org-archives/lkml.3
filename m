Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaAPARF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:17:05 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:35077 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaAPARD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:17:03 -0500
Date: Thu, 16 Jan 2014 02:16:54 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org, cl@linux-foundation.org
Subject: Re: [RFC][PATCH 3/9] mm: page->pfmemalloc only used by slab/skb
Message-ID: <20140116001654.GB8456@node.dhcp.inet.fi>
References: <20140114180042.C1C33F78@viggo.jf.intel.com>
 <20140114180051.0181E467@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114180051.0181E467@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:00:51AM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> page->pfmemalloc does not deserve a spot in 'struct page'.  It is
> only used transiently _just_ after a page leaves the buddy
> allocator.
> 
> Instead of declaring a union, we move its functionality behind a
> few quick accessor functions.  This way we could also much more
> easily audit that it is being used correctly in debugging
> scenarios.  For instance, we could store a magic number in there
> which could never get reused as a page->index and check that the
> magic number exists in page_pfmemalloc().
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
