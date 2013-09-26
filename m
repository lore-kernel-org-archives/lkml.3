Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3IZPeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:34:11 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62714 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3IZPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
References: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
Date: Thu, 26 Sep 2013 08:34:04 -0700
X-Google-Sender-Auth: 7OssSOTKnIa0tLoJ7fs3G20o0AE
Message-ID: <CA+55aFzCiOxpgdJagSVdsBYEU66zBSBXZpnU5-jvQpAX6T7SiA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] asm-generic: cmpxchg: implement dummy
 cmpxchg64_relaxed operation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 8:13 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> This patch implements a dummy implementation for asm-generic, falling
> back to the usual cmpxchg64 code.

I don't like the "let's add dummy operations for everybody who doesn't
care" when it is this specialized.

I'd much rather just add a single

   #ifndef cmpxchg64_relaxed
   # define cmpxchg64_relaxed cmpxchg64
   #endif

to the LOCKREF code, and then ARM (and others) can define it as they wish.

And *if* anybody else ever realizes that they want this outside of the
lockref code, let's look at doing that then. Right now I don't know of
any users, and I'd be leery of people using this willy-nilly, because
very few people really understand memory ordering.

               Linus
