Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaHXAzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 20:55:20 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49853 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaHXAzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 20:55:18 -0400
Date: Sat, 23 Aug 2014 20:55:17 -0400
From: Peter Feiner <pfeiner@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/3] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140824005517.GB12184@google.com>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-2-git-send-email-pfeiner@google.com>
 <20140823230011.GA26483@node.dhcp.inet.fi>
 <20140823235058.GA27234@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823235058.GA27234@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 02:50:58AM +0300, Kirill A. Shutemov wrote:
> One more case to consider: mprotect() which doesn't trigger successful
> vma_merge() will not set VM_SOFTDIRTY and will not enable write-protect on
> the vma.
> 
> It's probably better to take VM_SOFTDIRTY into account in
> vma_wants_writenotify() and re-think logic in other corners.

Merge or not, write notifications get disabled! I'll fix this too :-)

Peter
