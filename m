Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936059AbaH0V5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:57:17 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47703 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaH0V5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:57:15 -0400
Date: Wed, 27 Aug 2014 14:55:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
In-Reply-To: <20140826064952.GR25918@moon>
Message-ID: <alpine.LSU.2.11.1408271443290.7961@eggly.anvils>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com> <1408937681-1472-1-git-send-email-pfeiner@google.com> <alpine.LSU.2.11.1408252142380.2073@eggly.anvils> <20140826064952.GR25918@moon>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Cyrill Gorcunov wrote:
> On Mon, Aug 25, 2014 at 09:45:34PM -0700, Hugh Dickins wrote:
> > 
> > Hmm.  For a long time I thought you were fixing another important bug
> > with down_write, since we "always" use down_write to modify vm_flags.
> > 
> > But now I'm realizing that if this is the _only_ place which modifies
> > vm_flags with down_read, then it's "probably" safe.  I've a vague
> > feeling that this was discussed before - is that so, Cyrill?
> 
> Well, as far as I remember we were not talking before about vm_flags
> and read-lock in this function, maybe it was on some unrelated lkml thread
> without me CC'ed? Until I miss something obvious using read-lock here
> for vm_flags modification should be safe, since the only thing which is
> important (in context of vma-softdirty) is the vma's presence. Hugh,
> mind to refresh my memory, how long ago the discussion took place?

Sorry for making you think you were losing your mind, Cyrill.

I myself have no recollection of any such conversation with you;
but afraid that I might have lost _my_ memory of it - I didn't want
to get too strident about how fragile (though probably not yet buggy)
this down_read-for-updating-VM_SOFTDIRTY-onlyi is, if there had already
been such a discussion, coming to the conclusion that it is okay for now.

I am fairly sure that I have had some such discussion before; but
probably with someone else, probably still about mmap_sem and vm_flags,
but probably some other VM_flag: the surprising realization that it may
be safe but fragile to use just down_read for updating one particular flag.

Hugh
