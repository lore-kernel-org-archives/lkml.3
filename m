Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaLWAVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:21:23 -0500
Received: from ozlabs.org ([103.22.144.67]:48886 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaLWAVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:21:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>, Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] modules-next
In-Reply-To: <CA+55aFxS_JuFE+RM8cjeLx5tXu8XJVznfyrD4MSUqV85gPfx0w@mail.gmail.com>
References: <8761d8tq4p.fsf@rustcorp.com.au> <CA+55aFxS_JuFE+RM8cjeLx5tXu8XJVznfyrD4MSUqV85gPfx0w@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 22 Dec 2014 11:51:10 +1030
Message-ID: <87zjagv5rt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Thu, Dec 18, 2014 at 4:55 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> The exciting thing here is the getting rid of stop_machine on module
>> removal.  This is possible by using a simple atomic_t for the counter,
>> rather than our fancy per-cpu counter: it turns out that no one is doing
>> a module increment per net packet, so the slowdown should be in the noise.
>
> Famous last words. It may not happen per-packet, but I see
> module_get() in various block drivers and in netfilter code etc, and
> some of them may be pretty bad.
>
> Let's see how it all works out.

Indeed.  The general pattern is "get on open/init"; get-on-every-use was
most useful combined with blocking rmmod, which we removed a few kernels
ago (because no one used it).

I did a random audit until I got bored, and I put a printk-on-module-get
in my kernels for a while, and none of my usecases flood my logs.  But
it's definitely a risk...

Cheers,
Rusty.
