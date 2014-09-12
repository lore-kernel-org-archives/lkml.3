Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaILVOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:14:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:14:31 -0400
Date: Fri, 12 Sep 2014 14:14:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, christoffer.dall@linaro.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH] mm: export symbol dependencies of is_zero_pfn()
Message-Id: <20140912141429.17d570d1a7e1cb99ec73f0f7@linux-foundation.org>
In-Reply-To: <1410553043-575-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1410553043-575-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 22:17:23 +0200 Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> In order to make the static inline function is_zero_pfn() callable by
> modules, export its symbol dependencies 'zero_pfn' and (for s390 and
> mips) 'zero_page_mask'.

So hexagon and score get the export if/when needed.

> We need this for KVM, as CONFIG_KVM is a tristate for all supported
> architectures except ARM and arm64, and testing a pfn whether it refers
> to the zero page is required to correctly distinguish the zero page
> from other special RAM ranges that may also have the PG_reserved bit
> set, but need to be treated as MMIO memory.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/mips/mm/init.c | 1 +
>  arch/s390/mm/init.c | 1 +
>  mm/memory.c         | 2 ++

Looks OK to me.  Please include the patch in whichever tree is is that
needs it, and merge it up via that tree.

