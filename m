Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3LXAAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:00:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab3LXAAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:00:46 -0500
Message-ID: <52B8CE99.2050608@zytor.com>
Date: Mon, 23 Dec 2013 16:00:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] speeding up the stat() family of system calls...
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
In-Reply-To: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2013 12:27 PM, Linus Torvalds wrote:
> 
> HOWEVER. On x86, doing an efficient field-at-a-time copy also requires
> us to use put_user_try() and put_user_catch() in order to not have
> tons of clac/stac instructions for the extended permission testing.
> And the implementation of that was actually fairly non-optimal, so to
> actually get the code I wanted, I had to change how that all worked
> too, using "asm_volatile_goto()".
> 

I guess I'm a bit puzzled... the current code should be just fine if
everything is present, and do we really care about the performance if we
actually have an error condition?

I'm a bit concerned about the put_user_fail: label having uniqueness
problem, which I know some versions of gcc at least get very noisy over.

I like the overall approach, however.

	-hpa

