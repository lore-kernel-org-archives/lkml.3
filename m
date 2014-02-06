Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaBFTVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:21:18 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:44703 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBFTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:21:16 -0500
MIME-Version: 1.0
In-Reply-To: <21984.1391711149@warthog.procyon.org.uk>
References: <20140206134825.305510953@infradead.org>
	<21984.1391711149@warthog.procyon.org.uk>
Date: Thu, 6 Feb 2014 11:21:15 -0800
X-Google-Sender-Auth: _cykKdiEhbSZA0WapmemLSUcDNU
Message-ID: <CA+55aFxc+GSxP2xeS8D0p7pFuPHpk-Hs6in38cnJdNL62rxYFQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        ramana.radhakrishnan@arm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 10:25 AM, David Howells <dhowells@redhat.com> wrote:
>
> Is it worth considering a move towards using C11 atomics and barriers and
> compiler intrinsics inside the kernel?  The compiler _ought_ to be able to do
> these.

I think that's a bad idea as a generic implementation, but it's quite
possibly worth doing on an architecture-by-architecture basis.

The thing is, gcc builtins sometimes suck. Sometimes it's because
certain architectures want particular gcc versions that don't do a
good job, sometimes it's because the architecture doesn't lend itself
to doing what we want done and we end up better off with some tweaked
thing, sometimes it's because the language feature is just badly
designed. I'm not convinced that the C11 people got things right.

But in specific cases, maybe the architecture wants to use the
builtin. And the gcc version checks are likely to be
architecture-specific for a longish while. So some particular
architectures might want to use them, but I really doubt it makes
sense to make it the default with arch overrides.

                Linus
