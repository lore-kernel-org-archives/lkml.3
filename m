Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaKJH4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:56:16 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55186 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaKJH4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:56:14 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 9 Nov 2014 23:56:04 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: Re: linux-next: build failure after merge of the tiny tree
Message-ID: <20141110075604.GA1085@thin>
References: <20141110181716.3c9604fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110181716.3c9604fe@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:17:16PM +1100, Stephen Rothwell wrote:
> Hi Josh,
> 
> After merging the tiny tree, today's linux-next build (powerpc64 allnoconfig)
> failed like this:
> 
> arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> (.rodata+0xd58): undefined reference to `.compat_sys_adjtimex'
> arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> (.rodata+0x1b48): undefined reference to `.compat_sys_clock_adjtime'
> 
> Caused by commit be1e48a8e48f ("kernel: time: Compile out NTP support").

Good catch, thanks.  Not clear why that build failure didn't show up on
x86.

Looks like the two compat syscalls need cond_syscall lines as well.
I'll add those to the patch.

- Josh Triplett
