Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaKJRyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:54:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33020 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaKJRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:54:11 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 10 Nov 2014 09:54:03 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: Re: linux-next: build failure after merge of the tiny tree
Message-ID: <20141110175403.GA18766@thin>
References: <20141110181716.3c9604fe@canb.auug.org.au>
 <20141110075604.GA1085@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110075604.GA1085@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 11:56:04PM -0800, Josh Triplett wrote:
> On Mon, Nov 10, 2014 at 06:17:16PM +1100, Stephen Rothwell wrote:
> > Hi Josh,
> > 
> > After merging the tiny tree, today's linux-next build (powerpc64 allnoconfig)
> > failed like this:
> > 
> > arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> > (.rodata+0xd58): undefined reference to `.compat_sys_adjtimex'
> > arch/powerpc/kernel/built-in.o: In function `sys_call_table':
> > (.rodata+0x1b48): undefined reference to `.compat_sys_clock_adjtime'
> > 
> > Caused by commit be1e48a8e48f ("kernel: time: Compile out NTP support").
> 
> Good catch, thanks.  Not clear why that build failure didn't show up on
> x86.
> 
> Looks like the two compat syscalls need cond_syscall lines as well.
> I'll add those to the patch.

Done in current tiny/next.

- Josh Triplett
