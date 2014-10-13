Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaJMNmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:42:07 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55559 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaJMNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:42:05 -0400
Date: Mon, 13 Oct 2014 14:41:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Helge Deller <deller@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        "Carlos O'Donell" <carlos@systemhalted.org>
Subject: Re: [GIT PULL] parisc architecture patch for v3.18
Message-ID: <20141013144143.475ca9f9@alan.etchedpixels.co.uk>
In-Reply-To: <20141012100837.GA1553@p100.box>
References: <20141012100837.GA1553@p100.box>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014 12:08:37 +0200
Helge Deller <deller@gmx.de> wrote:

> Hi Linus,
> 
> please pull one patch for the parisc architecture for kernel 3.18 from 
>   git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.18-1
> 
> This patch intentionally breaks the ABI on PARISC Linux!
> 
> It assigns new numbers to SIGSTKFLT, SIGXCPU, SIGXFSZ and SIGSYS so that
> those are below 32 and thus leaves us with 32 RT signals like other
> Linux architectures (SIGRTMIN now becomes 32 instead of 37).
> 
> Even if it breaks the ABI, it doesn't seem to have any visible impact on
> existing userspace applications.

I somehow doubt your kill command magically corrects its signal numbering
table. Likewise what does gdb do given a core dump that died from one of
those signals, and what does your shell report if you kill one that way.
It seems to me your minimal set of binaries to swap to get it right is
non-zero but not problematic (libc, kill, shells, top, gdb) ?

I can however really only think of one app that actually *used* SIGXCPU,
and that was to respawn itself to avoid annoying sysadmin set CPU limits
anyway.

Alan
