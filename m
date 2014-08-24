Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaHXTWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:22:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34372 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaHXTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:22:54 -0400
Date: Sun, 24 Aug 2014 23:22:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Feiner <pfeiner@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140824192251.GL25918@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408844584-30380-1-git-send-email-pfeiner@google.com>
 <20140824075924.GA27392@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824075924.GA27392@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 10:59:24AM +0300, Kirill A. Shutemov wrote:
...
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index c1f2ea4..1b61fbc 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1470,6 +1470,10 @@ int vma_wants_writenotify(struct vm_area_struct *vma)
> >  	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
> >  		return 1;
> >  
> > +	/* Do we need to track softdirty? */
> > +	if (!(vm_flags & VM_SOFTDIRTY))
> 
> This will give false-positive if CONFIG_MEM_SOFT_DIRTY is disabled, since
> VM_SOFTDIRTY is 0 in this case:
> 
> 	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY))
> 
> Otherwise looks good to me.
> 
> Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Really sorry for delay. Thanks a huge, guys!

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
