Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947451Ab3BHX5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:57:30 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52352 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947361Ab3BHX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
	<CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
	<alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
	<20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
	<20130206214646.GA28135@gmail.com>
	<20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
	<20130208145539.GC30334@gmail.com>
	<CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
Date: Sat, 9 Feb 2013 01:57:27 +0200
X-Google-Sender-Auth: jzoHIQii9iBOZNOSAJJz9dS7irY
Message-ID: <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I'm going to go out on a limb here and say that this might the odd out
case that's not really supposed to happen where *you* are just WRONG,
CRAZY, and IGNORING REALITY.

On Fri, Feb 8, 2013 at 11:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think merging it would be an active mistake, and would just tie two
> projects together that just shouldn't be tied together.

The two are already tied together - that was the whole premise of the
project!

What Ingo proposed two years ago was to implement a (simple) userspace
counterpart of KVM under tools/kvm using kernel development process
and reusing kernel code as much as possible. He predicted that we'd
eventually have:

  - a clean codebase that's accessible to new developers

  - new kernel features developed in 'lock-step' with the userspace code

  - encouraged kernel developers to write userspace code

As it turns out, Ingo's predictions were correct. We support KVM on
ARMv8 even before the in-kernel code has hit mainline. People
implemented vhost drivers in lock-step. Most of the contributors are
also kernel developers. And we in fact have a clean codebase that's
accessible to anyone who knows the kernel coding style.

I honestly don't see any of these things happening had we not taken the
path suggested by Ingo early on.

On Fri, Feb 8, 2013 at 11:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> The fact that kvmtool isn't available as a standalone project probably
> keeps people actively from using it. You can't just fetch kvmtool. You
> have to fetch the kernel and kvmtool, and if you're a kernel developer
> you either have to make a whole new kernel tree for it (which is
> stupid) or merge it into your normal kernel tree that has development
> that has nothing to do with kvmtool (which is stupid AND F*CKING
> INSANE)

Actually, as a kernel developer, you don't need to do that. You can
'make install' from a kvmtool branch and leave it at that - just like
with perf. [ And if it was in your tree, you'd wouldn't even need the
branch ;-). ]

And yes, you are absolutely correct that living in the kernel tree is
suboptimal for the casual user. However, it's a trade-off to make
tools/kvm *development* easier especially when you need to touch both
kernel and userspace code.

On Fri, Feb 8, 2013 at 11:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> "git" is a hell of a lot more useful utility for kernel development,
> to the point that practically we couldn't do without it any more, and
> it isn't merged into the kernel. It's a separate project with a
> separate life, and it is *better* for it.

Sure but the difference between "git" and kvmtool is that a significant
chuck of kvmtool development is directly related to in-kernel KVM and
device drivers. That's why I've argued from day one that tools/kvm is
'special'.

			Pekka
