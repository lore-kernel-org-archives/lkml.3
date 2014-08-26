Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaHZPoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:44:16 -0400
Received: from mta-out1.inet.fi ([62.71.2.228]:37344 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaHZPoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:44:14 -0400
Date: Tue, 26 Aug 2014 18:43:55 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140826154355.GA11464@node.dhcp.inet.fi>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408937681-1472-1-git-send-email-pfeiner@google.com>
 <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
 <20140826064952.GR25918@moon>
 <20140826140419.GA10625@node.dhcp.inet.fi>
 <20140826141914.GA8952@moon>
 <20140826145612.GA11226@node.dhcp.inet.fi>
 <20140826151813.GB8952@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826151813.GB8952@moon>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 07:18:13PM +0400, Cyrill Gorcunov wrote:
> > Basically, it's safe if only soft-dirty is allowed to modify vm_flags
> > without down_write(). But why is soft-dirty so special?
> 
> because how we use this bit, i mean in normal workload this bit won't
> be used intensively i think so it's not widespread in kernel code

Weak argument to me.

What about walk through vmas twice: first with down_write() to modify
vm_flags and vm_page_prot, then downgrade_write() and do
walk_page_range() on every vma?

-- 
 Kirill A. Shutemov
