Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaBDSlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:41:22 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51569 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBDSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <87fvny238i.fsf@tassilo.jf.intel.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
	<alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
	<CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
	<20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
	<alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
	<20140204090809.GA19156@gmail.com>
	<CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
	<87fvny238i.fsf@tassilo.jf.intel.com>
Date: Tue, 4 Feb 2014 10:41:20 -0800
X-Google-Sender-Auth: XcXLAkmX_0GR6Kh9OZ2ck71TxOg
Message-ID: <CA+55aFzDp70dv=eCwuOr=gAPVBKaDVUyvFbqedrRJXhUDeHnfQ@mail.gmail.com>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 9:32 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> I have used debug info on allyesconfig in the past to run statistics
> on the resulting binary. It's still useful, even though quite slow.
> Make it depend on !EXPERT or somesuch? I agree for normal usages it's fine.

EXPERT is useless, people set it randomly.

I'd suggest that for any statistics gathering, you just disable
COMPILE_TEST. You can do that by just editing the .config file after
doing the allyesconfig, or by pre-seeding the allyesconfig with
COMPILE_TEST disabled.

Your use-case is rather special, after all. I do *not* believe that we
should make one of the goals of "make all{yes,mod}config" be that kind
of odd specialized thing.

> BTW you probably also want to do the same for the x86 instruction
> decoder test. It seems to be the biggest compile time waster in
> allyesconfig and I usually disable it too.

Agreed, that should be disabled too by default. Although in that case
I think the COMPILE_TEST combination makes more sense, since it's a
coverage issue.

Suggestions for symbols?

                 Linus
