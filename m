Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbaI2UJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:09:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:53943 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaI2UJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:09:46 -0400
Date: Mon, 29 Sep 2014 22:10:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andy Lutomirski <luto@amacapital.net>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
In-Reply-To: <5429BAA7.8060406@zytor.com>
Message-ID: <alpine.DEB.2.02.1409292208100.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de> <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com>
 <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de> <5429B664.4060003@zytor.com> <alpine.DEB.2.02.1409292152270.22082@ionos.tec.linutronix.de> <5429BAA7.8060406@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, H. Peter Anvin wrote:
> On 09/29/2014 12:57 PM, Thomas Gleixner wrote:
> >  
> >> I think we should mask the bit anyway.
> > 
> > I tend to disagree. If we clear it there we need to consequentely
> > audit ALL other possibilites and if there are any we need to clear the
> > bit there as well. Just to make buggy user space happy?
> > 
> 
> The entry options into the kernel are: interrupt/exception (already
> known to be OK), SYSENTER32, SYSCALL32, and SYSCALL64.  It is not too
> much to work through those issues, I don't think.

Fair enough.

I still don't see why we should care. Supporting buggy user space was
never high on my list.

Thanks,

	tglx


