Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaEEXbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:31:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaEEXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:31:24 -0400
Date: Mon, 5 May 2014 16:31:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        torvalds@linux-foundation.org, mgorman@suse.de, hpa@zytor.com,
        mingo@kernel.org, steven@uplinklabs.net, riel@redhat.com,
        david.vrabel@citrix.com, peterz@infradead.org, xemul@parallels.com
Subject: Re: [patch 2/2] mm: pgtable -- Require X86_64 for soft-dirty
 tracker
Message-Id: <20140505163123.65e6f8853cdf0646f26bd5b4@linux-foundation.org>
In-Reply-To: <20140425082042.848656782@openvz.org>
References: <20140425081030.185969086@openvz.org>
	<20140425082042.848656782@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014 12:10:32 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Tracking dirty status on 2 level pages requires very ugly macros
> and taking into account how old the machines who can operate
> without PAE mode only are, lets drop soft dirty tracker from
> them for code simplicity (note I can't drop all the macros
> from 2 level pages by now since _PAGE_BIT_PROTNONE and
> _PAGE_BIT_FILE are still used even without tracker).
> 
> Linus proposed to completely rip off softdirty support on
> x86-32 (even with PAE) and since for CRIU we're not planning
> to support native x86-32 mode, lets do that.
> 
> (Softdirty tracker is relatively new feature which mostly used
>  by CRIU so I don't expect if such API change would cause problems
>  on userspace).

i386 allnoconfig:

In file included from /usr/src/25/arch/x86/include/asm/pgtable.h:886,
                 from include/linux/mm.h:51,
                 from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets.c:12:
include/asm-generic/pgtable.h:414: error: redefinition of 'pte_soft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:300: note: previous definition of 'pte_soft_dirty' was here
include/asm-generic/pgtable.h:419: error: redefinition of 'pmd_soft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:305: note: previous definition of 'pmd_soft_dirty' was here
include/asm-generic/pgtable.h:424: error: redefinition of 'pte_mksoft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:310: note: previous definition of 'pte_mksoft_dirty' was here
include/asm-generic/pgtable.h:429: error: redefinition of 'pmd_mksoft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:315: note: previous definition of 'pmd_mksoft_dirty' was here
include/asm-generic/pgtable.h:434: error: redefinition of 'pte_swp_mksoft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:868: note: previous definition of 'pte_swp_mksoft_dirty' was here
include/asm-generic/pgtable.h:439: error: redefinition of 'pte_swp_soft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:874: note: previous definition of 'pte_swp_soft_dirty' was here
include/asm-generic/pgtable.h:444: error: redefinition of 'pte_swp_clear_soft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:880: note: previous definition of 'pte_swp_clear_soft_dirty' was here
include/asm-generic/pgtable.h:449: error: redefinition of 'pte_file_clear_soft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:320: note: previous definition of 'pte_file_clear_soft_dirty' was here
include/asm-generic/pgtable.h:454: error: redefinition of 'pte_file_mksoft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:325: note: previous definition of 'pte_file_mksoft_dirty' was here
include/asm-generic/pgtable.h:459: error: redefinition of 'pte_file_soft_dirty'
/usr/src/25/arch/x86/include/asm/pgtable.h:330: note: previous definition of 'pte_file_soft_dirty' was here

