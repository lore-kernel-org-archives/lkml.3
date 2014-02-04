Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaBDQgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:36:17 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49051 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:36:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140204090809.GA19156@gmail.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
	<alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
	<CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
	<20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
	<alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
	<20140204090809.GA19156@gmail.com>
Date: Tue, 4 Feb 2014 08:36:14 -0800
X-Google-Sender-Auth: lx-eRAQgS1135zlw_MXl2A7KYXs
Message-ID: <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 1:08 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>  config SAVE_TIME_AND_DISK_SPACE
>         bool "Faster and leaner build object files: compile without debug info"
>         default y

Thinking about it, we already have this. It's called "CONFIG_COMPILE_TEST".

It very much gets set by all{yes,mod}config, and it also says "we're
interested in testing the compile, not so much running the result".

So let's just make the DEBUG_INFO depend on !COMPILE_TEST.

Trivial oneliner patch (independent of the discussion about improving
the documentation), so I'll just apply it.

I can't imagine that this would be controversial:

   config DEBUG_INFO
          bool "Compile the kernel with debug info"
  -       depends on DEBUG_KERNEL
  +       depends on DEBUG_KERNEL && !COMPILE_TEST
          help

Hm?

              Linus
