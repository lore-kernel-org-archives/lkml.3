Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaBEFqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:46:19 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52128 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaBEFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:46:17 -0500
Date: Wed, 5 Feb 2014 06:46:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
Message-ID: <20140205054613.GA30094@gmail.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
 <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
 <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
 <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
 <alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
 <20140204090809.GA19156@gmail.com>
 <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Feb 4, 2014 at 1:08 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >  config SAVE_TIME_AND_DISK_SPACE
> >         bool "Faster and leaner build object files: compile without debug info"
> >         default y
> 
> Thinking about it, we already have this. It's called "CONFIG_COMPILE_TEST".
> 
> It very much gets set by all{yes,mod}config, and it also says "we're
> interested in testing the compile, not so much running the result".
> 
> So let's just make the DEBUG_INFO depend on !COMPILE_TEST.
> 
> Trivial oneliner patch (independent of the discussion about improving
> the documentation), so I'll just apply it.
> 
> I can't imagine that this would be controversial:
> 
>    config DEBUG_INFO
>           bool "Compile the kernel with debug info"
>   -       depends on DEBUG_KERNEL
>   +       depends on DEBUG_KERNEL && !COMPILE_TEST
>           help
> 
> Hm?

Fully agreed.

Thanks,

	Ingo
