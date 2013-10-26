Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3JZUD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:03:58 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:53824 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3JZUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:03:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131026113238.GC1792@Nokia-N900>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
	<20131025091842.GA28681@thunk.org>
	<20131025022937.12623dcd.akpm@linux-foundation.org>
	<CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
	<20131026113238.GC1792@Nokia-N900>
Date: Sat, 26 Oct 2013 13:03:56 -0700
X-Google-Sender-Auth: 0RSMrceYxz6tqTovNYao_JP4uQQ
Message-ID: <CA+55aFw9c4e+47rGif5CLwJ8PP77uuGhEr0t5vXig7QStOnYzw@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 4:32 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> Hmm, I'd expect the result to be "dead USB key". Putting
> ext3 on cheap flash device normally just kills the devic :-(.

Not my experience. It may be true for some really cheap devices, but
normal USB keys seem to just get really slow, probably due to having
had their flash rewrite algorithm tuned for FAT accesses.

I *do* suspect that to see the really bad behavior, you don't write
just one large file to it, but many smaller ones. "git clone" will
check out all the kernel tree files, obviously.

                     Linus
