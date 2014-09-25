Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIYHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:13:10 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53472 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIYHNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:13:09 -0400
Date: Thu, 25 Sep 2014 10:30:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Feiner <pfeiner@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: softdirty: keep bit when zapping file pte
Message-ID: <20140925063006.GN2227@moon>
References: <1411200187-40896-1-git-send-email-pfeiner@google.com>
 <20140924145927.04e8eb7ba6c1410a797293c7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924145927.04e8eb7ba6c1410a797293c7@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 02:59:27PM -0700, Andrew Morton wrote:
> On Sat, 20 Sep 2014 01:03:07 -0700 Peter Feiner <pfeiner@google.com> wrote:
> 
> > Fixes the same bug as b43790eedd31e9535b89bbfa45793919e9504c34 and
> > 9aed8614af5a05cdaa32a0b78b0f1a424754a958 where the return value of
> > pte_*mksoft_dirty was being ignored.
> > 
> > To be sure that no other pte/pmd "mk" function return values were
> > being ignored, I annotated the functions in
> > arch/x86/include/asm/pgtable.h with __must_check and rebuilt.
> > 
> 
> Grumble.
> 
> It is useful to identify preceding similar patches but that isn't a
> good way of describing *this* patch.  What is wrong with the current
> code, how does the patch fix it.

The userspace effect is that without this patch softdirty mark might be lost
if file mapped pte get zapped. It should go into @stable series after 3.12.

> 
> And, particularly, what do you think are the end-user visible effects
> of the bug?  This info helps people to work out which kernel versions
> need the fix.
