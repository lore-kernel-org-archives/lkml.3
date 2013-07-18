Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3GRA6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:58:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46292 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3GRA6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:58:04 -0400
Date: Wed, 17 Jul 2013 17:58:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Hansen <dave@sr71.net>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thp, mm: locking tail page is a bug
In-Reply-To: <51E71E29.6030703@sr71.net>
Message-ID: <alpine.LNX.2.00.1307171747210.23502@eggly.anvils>
References: <1373885274-25249-1-git-send-email-kirill.shutemov@linux.intel.com> <1373885274-25249-6-git-send-email-kirill.shutemov@linux.intel.com> <20130717140953.7560e88e607f8f5df1b1fdd8@linux-foundation.org> <51E71E29.6030703@sr71.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Dave Hansen wrote:
> On 07/17/2013 02:09 PM, Andrew Morton wrote:
> > lock_page() is a pretty commonly called function, and I assume quite a
> > lot of people run with CONFIG_DEBUG_VM=y.
> > 
> > Is the overhead added by this patch really worthwhile?
> 
> I always thought of it as a developer-only thing.  I don't think any of
> the big distros turn it on by default.

That's how I think of it too (and the problem is often that too few mm
developers turn it on); but Dave Jones did confirm last November that
Fedora turns it on.

I believe Fedora turns it on to help us all, and wouldn't mind a mere
VM_BUG_ON(PageTail(page)) in __lock_page() if it's helpful to Kirill.

But if VM_BUG_ONs become expensive, I do think it's for Fedora to
turn off CONFIG_DEBUG_VM, rather than for mm developers to avoid it.

Hugh
