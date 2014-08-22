Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaHVGdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:33:35 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48856 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaHVGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:33:34 -0400
Date: Fri, 22 Aug 2014 10:33:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] mm: softdirty: write protect PTEs created for read
 faults after VM_SOFTDIRTY cleared
Message-ID: <20140822063331.GJ14072@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <20140820234543.GA7987@node.dhcp.inet.fi>
 <20140821193737.GC16042@google.com>
 <20140821205115.GH14072@moon>
 <20140821213942.GA15218@node.dhcp.inet.fi>
 <20140821214601.GD16042@google.com>
 <20140821215147.GA15482@node.dhcp.inet.fi>
 <20140821225033.GE16042@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821225033.GE16042@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 06:50:33PM -0400, Peter Feiner wrote:
> On Fri, Aug 22, 2014 at 12:51:47AM +0300, Kirill A. Shutemov wrote:
> > > > One thing: there could be (I haven't checked) complications on
> > > > vma_merge(): since vm_flags are identical it assumes that it can reuse
> > > > vma->vm_page_prot of expanded vma. But VM_SOFTDIRTY is excluded from
> > > > vm_flags compatibility check. What should we do with vm_page_prot there?
> > > 
> > > Since the merged VMA will have VM_SOFTDIRTY set, it's OK that it's vm_page_prot
> > > won't be setup for write notifications. For the purpose of process migration,
> > > you'll just get some false positives, which is tolerable.
> > 
> > Right. But should we disable writenotify back to avoid exessive wp-faults
> > if it was enabled due to soft-dirty (the case when expanded vma is
> > soft-dirty)?
> 
> Ah, I understand now. I've got a patch in the works that disables the write
> faults when a VMA is merged. I'll send a series with all of the changes
> tomorrow.

Cool! Thanks a lot, guys!
