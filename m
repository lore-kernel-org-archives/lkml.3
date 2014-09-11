Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIKTyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:54:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaIKTyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:54:37 -0400
Date: Thu, 11 Sep 2014 12:54:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm: softdirty: unmapped addresses between VMAs are
 clean
Message-Id: <20140911125436.51338d98e8e84abacc418aff@linux-foundation.org>
In-Reply-To: <20140911054104.GA31069@google.com>
References: <1410391486-9106-1-git-send-email-pfeiner@google.com>
	<20140910163628.66302ac77f7835ba5df2f49c@linux-foundation.org>
	<20140911054104.GA31069@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 22:41:04 -0700 Peter Feiner <pfeiner@google.com> wrote:

> On Wed, Sep 10, 2014 at 04:36:28PM -0700, Andrew Morton wrote:
> > On Wed, 10 Sep 2014 16:24:46 -0700 Peter Feiner <pfeiner@google.com> wrote:
> > > @@ -1048,32 +1048,51 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > > +	while (1) {
> > > +		unsigned long vm_start = end;
> > 
> > Did you really mean to do that?  If so, perhaps a little comment to
> > explain how it works?
> 
> It's the same idea that I used in the pagemap_pte_hole patch that I submitted
> today: if vma is NULL, then we fill in the pagemap from (addr) to (end) with
> non-present pagemap entries. 
> 
> Should I submit a v2 with a comment?

I spent quite some time staring at that code wondering wtf, so anything
you can do to clarify it would be good.

I think a better name would be plain old "start", to communicate that
it's just a local convenience variable.  "vm_start" means "start of a
vma" and that isn't accurate in this context; in fact it is misleading.

