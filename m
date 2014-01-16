Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaAPWYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:24:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaAPWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:24:32 -0500
Date: Thu, 16 Jan 2014 14:24:56 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] sh: kgdb: Add missing #include <linux/sched.h>
Message-ID: <20140116222456.GA6723@kroah.com>
References: <1389910800-13083-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389910800-13083-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:20:00PM +0100, Geert Uytterhoeven wrote:
> From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
> arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
> arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
> arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
> arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
> arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
> arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in
> 
> This is introduced by commit 16559ae48c76f1ceb970b9719dea62b77eb5d06b
> ("kgdb: remove #include <linux/serial_8250.h> from kgdb.h").

Which showed up in 3.9-rc1, seems that no one seems to care about this
arch/config much :)

> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> [geert: Reworded and reformatted]
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Cc: stable <stable@vger.kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

