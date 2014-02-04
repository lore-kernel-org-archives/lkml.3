Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaBDRcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:32:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:26798 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbaBDRcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,781,1384329600"; 
   d="scan'208";a="477935981"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
	<alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
	<CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
	<20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
	<alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
	<20140204090809.GA19156@gmail.com>
	<CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
Date: Tue, 04 Feb 2014 09:32:13 -0800
In-Reply-To: <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 4 Feb 2014 08:36:14 -0800")
Message-ID: <87fvny238i.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
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

I have used debug info on allyesconfig in the past to run statistics
on the resulting binary. It's still useful, even though quite slow.
Make it depend on !EXPERT or somesuch? I agree for normal usages it's fine.

BTW you probably also want to do the same for the x86 instruction
decoder test. It seems to be the biggest compile time waster in
allyesconfig and I usually disable it too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
