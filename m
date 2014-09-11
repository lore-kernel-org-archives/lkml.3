Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaIKFlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:41:08 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:64732 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaIKFlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:41:06 -0400
Date: Wed, 10 Sep 2014 22:41:04 -0700
From: Peter Feiner <pfeiner@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm: softdirty: unmapped addresses between VMAs are clean
Message-ID: <20140911054104.GA31069@google.com>
References: <1410391486-9106-1-git-send-email-pfeiner@google.com>
 <20140910163628.66302ac77f7835ba5df2f49c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910163628.66302ac77f7835ba5df2f49c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 04:36:28PM -0700, Andrew Morton wrote:
> On Wed, 10 Sep 2014 16:24:46 -0700 Peter Feiner <pfeiner@google.com> wrote:
> > @@ -1048,32 +1048,51 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > +	while (1) {
> > +		unsigned long vm_start = end;
> 
> Did you really mean to do that?  If so, perhaps a little comment to
> explain how it works?

It's the same idea that I used in the pagemap_pte_hole patch that I submitted
today: if vma is NULL, then we fill in the pagemap from (addr) to (end) with
non-present pagemap entries. 

Should I submit a v2 with a comment?
