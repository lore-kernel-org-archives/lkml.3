Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaFWJSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:18:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaFWJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:18:24 -0400
Date: Mon, 23 Jun 2014 11:18:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tsc: get rid of custom DIV_ROUND
Message-ID: <20140623091818.GO19860@laptop.programming.kicks-ass.net>
References: <1403143116-21755-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403143116-21755-1-git-send-email-mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:58:36AM +0200, Michal Nazarewicz wrote:
> When invoced for positive values, DIV_ROUND macro defined in
> arch/x86/kernel/tsc.c behaves exactly like DIV_ROUND_CLOSEST from
> include/linux/kernel.h file, so remove the custom macro in favour
> of the shared one.

See, I knew we'd had one. _CLOSEST is a dumb postfix though, its the
default whenever people talk of rounding.

> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  arch/x86/kernel/tsc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
>  No changes after compilation:
> 
>  $ ll tsc.o.*
>  -rw------- 1 mpn eng 46497 Jun 19 03:54 tsc.o.after
>  -rw------- 1 mpn eng 46497 Jun 19 03:55 tsc.o.before
>  $ objdump -d tsc.o.before >tsc.s.before
>  $ objdump -d tsc.o.after >tsc.s.after
>  $ diff -u tsc.s.before tsc.s.after
>  --- tsc.s.before	2014-06-19 03:56:54.880545041 +0200
>  +++ tsc.s.after	2014-06-19 03:56:54.884545079 +0200
>  @@ -1,5 +1,5 @@
>   
>  -tsc.o.before:     file format elf64-x86-64
>  +tsc.o.after:     file format elf64-x86-64
>   
>   
>   Disassembly of section .text:
>  $

This diff in a diff totally confused patch.

Applies when I remove that.
