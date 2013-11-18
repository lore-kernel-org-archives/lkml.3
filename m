Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3KRXIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:08:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50601 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:08:06 -0500
Date: Mon, 18 Nov 2013 18:08:04 -0500 (EST)
Message-Id: <20131118.180804.1868971161928013977.davem@davemloft.net>
To: kirill.shutemov@linux.intel.com
Cc: geert@linux-m68k.org, sfr@canb.auug.org.au, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparc64: fix build regession
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384767850-2574-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1384767850-2574-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Nov 2013 15:08:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 18 Nov 2013 11:44:09 +0200

> Commit ea1e7ed33708 triggers build regression on sparc64.
> 
> include/linux/mm.h:1391:2: error: implicit declaration of function 'pgtable_cache_init' [-Werror=implicit-function-declaration]
> arch/sparc/include/asm/pgtable_64.h:978:13: error: conflicting types for 'pgtable_cache_init' [-Werror]
> 
> It happens due headers include loop:
> 
> <linux/mm.h> -> <asm/pgtable.h> -> <asm/pgtable_64.h> ->
> 	<asm/tlbflush.h> -> <asm/tlbflush_64.h> -> <linux/mm.h>
> 
> Let's drop <linux/mm.h> include from asm/tlbflush_64.h.
> Build tested with allmodconfig.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, please post sparc patches to sparclinux@vger.kernel.org in the
future so that I can properly track them.

Thanks.
