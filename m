Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaDKUhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:37:52 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:59888 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbaDKUhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:37:51 -0400
Date: Fri, 11 Apr 2014 23:36:57 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave@sr71.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: pass VM_BUG_ON() reason to dump_page()
Message-ID: <20140411203657.GA672@node.dhcp.inet.fi>
References: <20140411202125.01D1D100@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411202125.01D1D100@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:21:25PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> I recently added a patch to let folks pass a "reason" string
> dump_page() which gets dumped out along with the page's data.
> This essentially saves the bug-reader a trip in to the source
> to figure out why we BUG_ON()'d.
> 
> The new VM_BUG_ON_PAGE() passes in NULL for "reason".  It seems
> like we might as well pass the BUG_ON() condition if we have it.
> This will bloat kernels a bit with ~160 new strings, but this
> is all under a debugging option anyway.
> 
> 	page:ffffea0008560280 count:1 mapcount:0 mapping:(null) index:0x0
> 	page flags: 0xbfffc0000000001(locked)
> 	page dumped because: VM_BUG_ON_PAGE(PageLocked(page))
> 	------------[ cut here ]------------
> 	kernel BUG at /home/davehans/linux.git/mm/filemap.c:464!
> 	invalid opcode: 0000 [#1] SMP
> 	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0+ #251
> 	Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> 	...
> 
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

I see space-before-tabs in few places, otherwise:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
