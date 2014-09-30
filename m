Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaI3W1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:27:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:33853 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaI3W1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:27:52 -0400
Date: Wed, 1 Oct 2014 00:27:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Sebastian Lackner <sebastian@fds-team.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from
 userspace
In-Reply-To: <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410010025050.4455@nanos>
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net> <542B2305.9060805@fds-team.de> <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com>
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
> It would certainly be possible to clear NT and retry IRET if IRET
> fails with NT set.  This would have no overhead for anything relevant.
> That would be this alternative from my 0/2 email:
> 
>  - Don't filter NT on sysenter.  Instead, filter it on EFI entry
>    and modify the IRET code to retry without NT set if NT was set.
> 
> Thomas hpa, etc: any thoughts?

Filter it right away. That's solid and obvious. Anything else is just
complex and prone for future brown paperbag failures.

We get the context switch benefit from it, so there is some
compensation for the extra cycles.

Thanks,

	tglx
