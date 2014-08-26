Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaHZPxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:53:55 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40318 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaHZPxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:53:54 -0400
Date: Tue, 26 Aug 2014 19:53:51 +0400
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
Message-ID: <20140826155351.GC8952@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408937681-1472-1-git-send-email-pfeiner@google.com>
 <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
 <20140826064952.GR25918@moon>
 <20140826140419.GA10625@node.dhcp.inet.fi>
 <20140826141914.GA8952@moon>
 <20140826145612.GA11226@node.dhcp.inet.fi>
 <20140826151813.GB8952@moon>
 <20140826154355.GA11464@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826154355.GA11464@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 06:43:55PM +0300, Kirill A. Shutemov wrote:
> On Tue, Aug 26, 2014 at 07:18:13PM +0400, Cyrill Gorcunov wrote:
> > > Basically, it's safe if only soft-dirty is allowed to modify vm_flags
> > > without down_write(). But why is soft-dirty so special?
> > 
> > because how we use this bit, i mean in normal workload this bit won't
> > be used intensively i think so it's not widespread in kernel code
> 
> Weak argument to me.
> 
> What about walk through vmas twice: first with down_write() to modify
> vm_flags and vm_page_prot, then downgrade_write() and do
> walk_page_range() on every vma?

I still it's undeeded, but for sure using write-lock/downgrade won't hurt,
so no argues from my side.
