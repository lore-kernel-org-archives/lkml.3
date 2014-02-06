Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaBFR44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:56:56 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38027 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaBFR4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140206175201.GH5002@laptop.programming.kicks-ass.net>
References: <20140206134825.305510953@infradead.org>
	<20140206135001.333583247@infradead.org>
	<CA+55aFwzn09dPJekgCbO2VRO8j3=eEt2j_QFd=Gd4MXTA2gm9g@mail.gmail.com>
	<20140206175201.GH5002@laptop.programming.kicks-ass.net>
Date: Thu, 6 Feb 2014 09:56:54 -0800
X-Google-Sender-Auth: ymnhA_GlSyogyLUxQCHF4JhW3qk
Message-ID: <CA+55aFx=dDhYzp7yN5oiPT+_Gyffo+0hT5WRFd7eGeMz8oNnDg@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 9:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> s390 is stuffed with atomic_{set,clear}_mask usage, no clue whatfor.

It's not the set/clear_mask ones I would worry about.

It's the "_return" variants. As far as I can tell, there are exactly
ZERO users of that stuff, and they are BAD BAD BAD.

On x86, those things would cause a cmpxchg loop, and the bad
read-for-shared-before-acquire cacheline pattern.

So why indirectly encourage people to add users for a bad operation?

                        Linus
