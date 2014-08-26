Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbaHZOTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:19:24 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:56807 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaHZOTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:19:17 -0400
Date: Tue, 26 Aug 2014 18:19:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140826141914.GA8952@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408937681-1472-1-git-send-email-pfeiner@google.com>
 <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
 <20140826064952.GR25918@moon>
 <20140826140419.GA10625@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826140419.GA10625@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 05:04:19PM +0300, Kirill A. Shutemov wrote:
> > > 
> > > But now I'm realizing that if this is the _only_ place which modifies
> > > vm_flags with down_read, then it's "probably" safe.  I've a vague
> > > feeling that this was discussed before - is that so, Cyrill?
> > 
> > Well, as far as I remember we were not talking before about vm_flags
> > and read-lock in this function, maybe it was on some unrelated lkml thread
> > without me CC'ed? Until I miss something obvious using read-lock here
> > for vm_flags modification should be safe, since the only thing which is
> > important (in context of vma-softdirty) is the vma's presence. Hugh,
> > mind to refresh my memory, how long ago the discussion took place?
> 
> It seems safe in vma-softdirty context. But if somebody else will decide that
> it's fine to modify vm_flags without down_write (in their context), we
> will get trouble. Sasha will come with weird bug report one day ;)
> 
> At least vm_flags must be updated atomically to avoid race in middle of
> load-modify-store.

Which race you mean here? Two concurrent clear-refs?
