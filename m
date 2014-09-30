Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaI3WWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:22:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:33835 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaI3WWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:22:06 -0400
Date: Wed, 1 Oct 2014 00:21:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH 0/2] x86_64,entry: Clear NT on entry and speed up
 switch_to
In-Reply-To: <cover.1412105369.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1410010019290.4455@nanos>
References: <cover.1412105369.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Andy Lutomirski wrote:
> Anish Bhatt noticed that user programs can set RFLAGS.NT before
> syscall or sysenter, and the kernel entry code doesn't filter out
> NT.  This causes kernel C code and, depending on thread flags, the
> exit slow path to run with NT set.
> 
> The former is a little bit scary (imagine calling into EFI with NT
> set), and the latter will fail with #GP and send a spurious SIGSEGV.
> 
> One answer would be "don't do that".  But the kernel can do better
> here.
> 
> These patches, which I'm not completely thrilled by, filter NT on
> all kernel entries.  For syscall (both bitnesses), this is free.
> For sysenter, it costs 15 cycles or so.  As a consolation prize, we
> can speed up context switches by avoiding saving and restoring flags.

That's a nice reason not to do any of the other ugly variants.

Thanks,

	tglx
