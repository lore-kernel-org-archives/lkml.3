Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab3CDV44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:56:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41362 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab3CDV4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:56:55 -0500
Date: Mon, 4 Mar 2013 22:56:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86-64, docs, mm: Add vsyscall range to virtual
 address space layout
Message-ID: <20130304215639.GH22274@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1362428180-8865-1-git-send-email-bp@alien8.de>
 <1362428180-8865-4-git-send-email-bp@alien8.de>
 <513515F0.7050603@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <513515F0.7050603@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 01:45:20PM -0800, Andy Lutomirski wrote:
> vsyscalls are only 4k.  Am I missing something obvious her?

Right, but we're reserving 5 level2 pages for this, i.e. 5*512*4K = 10M.
I.e., each level2 page contains 512 ptes, each pointing to a 4K page.

arch/x86/kernel/head_64.S:

...
NEXT_PAGE(level2_fixmap_pgt)
	.fill	506,8,0
	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
	.fill	5,8,0

NEXT_PAGE(level1_fixmap_pgt)
	.fill	512,8,0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
