Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3K3AWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 19:22:04 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:39326 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3K3AWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 19:22:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
	<20131129183558.GA9803@redhat.com>
	<20131129195419.GB17656@two.firstfloor.org>
	<20131129200532.GA13561@redhat.com>
	<alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
Date: Fri, 29 Nov 2013 16:22:01 -0800
X-Google-Sender-Auth: GkmG_MPJImKrJMFOpOfAk7QvBdw
Message-ID: <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 3:24 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Do you think this'd be faster than the int3-based aproach?

Unlikely to be faster, but perhaps more robust and more portable. Maybe.

And the reason we use the int3-based approach is that doing TLB
shootdowns of kernel mappings is completely out of the question, not
to mention not portable (kernel code may not even be in a page table
to begin with).

Remember: the current text_poke is all about kernel code. So the rules
for user space may well be entirely different.

           Linus
