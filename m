Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaHUWCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:02:03 -0400
Received: from mta-out1.inet.fi ([62.71.2.228]:55304 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaHUWCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:02:01 -0400
Date: Fri, 22 Aug 2014 00:51:47 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Feiner <pfeiner@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] mm: softdirty: write protect PTEs created for read
 faults after VM_SOFTDIRTY cleared
Message-ID: <20140821215147.GA15482@node.dhcp.inet.fi>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <20140820234543.GA7987@node.dhcp.inet.fi>
 <20140821193737.GC16042@google.com>
 <20140821205115.GH14072@moon>
 <20140821213942.GA15218@node.dhcp.inet.fi>
 <20140821214601.GD16042@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821214601.GD16042@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 05:46:01PM -0400, Peter Feiner wrote:
> On Fri, Aug 22, 2014 at 12:39:42AM +0300, Kirill A. Shutemov wrote:
> > On Fri, Aug 22, 2014 at 12:51:15AM +0400, Cyrill Gorcunov wrote:
> > 
> > Looks good to me.
> > 
> > Would you mind to apply the same pgprot_modify() approach on the
> > clear_refs_write(), test and post the patch?
> > 
> > Feel free to use my singed-off-by (or suggested-by if you prefer) once
> > it's tested (see merge case below).
> 
> Sure thing :-)
> 
> > One thing: there could be (I haven't checked) complications on
> > vma_merge(): since vm_flags are identical it assumes that it can reuse
> > vma->vm_page_prot of expanded vma. But VM_SOFTDIRTY is excluded from
> > vm_flags compatibility check. What should we do with vm_page_prot there?
> 
> Since the merged VMA will have VM_SOFTDIRTY set, it's OK that it's vm_page_prot
> won't be setup for write notifications. For the purpose of process migration,
> you'll just get some false positives, which is tolerable.

Right. But should we disable writenotify back to avoid exessive wp-faults
if it was enabled due to soft-dirty (the case when expanded vma is
soft-dirty)?

-- 
 Kirill A. Shutemov
