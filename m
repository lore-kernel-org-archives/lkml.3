Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaCCW36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:29:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbaCCW35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:29:57 -0500
Message-ID: <1393885748.5094.14.camel@deneb.redhat.com>
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Dave Young <dyoung@redhat.com>, Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Mon, 03 Mar 2014 17:29:08 -0500
In-Reply-To: <530CF21E.1020603@zytor.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>
		 <1393337404.7307.51.camel@deneb.redhat.com>
		 <20140225183012.GA27164@mudshark.cambridge.arm.com>
	 <1393353942.26583.10.camel@deneb.redhat.com> <530CF21E.1020603@zytor.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 11:42 -0800, H. Peter Anvin wrote:
> On 02/25/2014 10:45 AM, Mark Salter wrote:
> > On Tue, 2014-02-25 at 18:30 +0000, Will Deacon wrote:
> >> I'd suggest spitting the core part out from the arch-specific parts. That
> >> way, the core part can merged independently and architectures can move over
> >> as they see fit. It also signals (at least to me) that, "hey, I should
> >> probably review this" whilst my current stance is "there's a whole load of
> >> stuff under mm/ that needs to be acked first".
> >>
> >> If you put the whole thing into next, you just run the risk of conflicts
> >> with all the arch trees.
> > 
> > I've been thinking of breaking out the common bits and x86 bits and just
> > going with that for now. There's no point in just doing the common bits
> > because it won't get tested without at least one architecture using it.
> > 
> 
> If you think it makes sense we could take the common bits + x86 and put
> them through the -tip tree.  The other option would be to put the whole
> thread in linux-next with Acks.
> 
> As far as x86 is concerned it looks like it is mostly just code
> movement, so I'm happy giving my:
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>
> 

I going to send out a v5 with the arm bits dropped and Ack-bys added.
There is still some work left there, so I think I'll redo the arm bits
separately after once the common bits are in the kernel.

Peter, is your Acked-by only for "[3/6] x86: use generic early_ioremap"?
Or did you intend "[1/6] x86/mm: sparse warning fix for early_memremap"
and/or "[2/6] mm: create generic early_ioremap() support" also?


