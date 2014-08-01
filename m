Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaHAHCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:02:01 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47852 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHAHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:02:00 -0400
Date: Fri, 1 Aug 2014 11:01:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: softdirty: respect VM_SOFTDIRTY in PTE holes
Message-ID: <20140801070156.GE17343@moon>
References: <1406846605-12176-1-git-send-email-pfeiner@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406846605-12176-1-git-send-email-pfeiner@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:43:25PM -0400, Peter Feiner wrote:
> After a VMA is created with the VM_SOFTDIRTY flag set,
> /proc/pid/pagemap should report that the VMA's virtual pages are
> soft-dirty until VM_SOFTDIRTY is cleared (i.e., by the next write of
> "4" to /proc/pid/clear_refs). However, pagemap ignores the
> VM_SOFTDIRTY flag for virtual addresses that fall in PTE holes (i.e.,
> virtual addresses that don't have a PMD, PUD, or PGD allocated yet).
> 
> To observe this bug, use mmap to create a VMA large enough such that
> there's a good chance that the VMA will occupy an unused PMD, then
> test the soft-dirty bit on its pages. In practice, I found that a VMA
> that covered a PMD's worth of address space was big enough.
> 
> This patch adds the necessary VMA lookup to the PTE hole callback in
> /proc/pid/pagemap's page walk and sets soft-dirty according to the
> VMAs' VM_SOFTDIRTY flag.
> 
> Signed-off-by: Peter Feiner <pfeiner@google.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
