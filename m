Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab3BIT6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:58:08 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:40730 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab3BIT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
 <20130204184436.GA13256@gmail.com> <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com> <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
 <20130206214646.GA28135@gmail.com> <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com> <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com> <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 10 Feb 2013 06:57:41 +1100
X-Google-Sender-Auth: S7gaq_X_riMCuFezPxNDE047POY
Message-ID: <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
To: Pekka Enberg <penberg@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 6:39 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> The main argument for merging into the main kernel repository has always been
> that (we think) it improves the kernel because significant amount of
> development is directly linked to kernel code (think KVM ARM port here, for
> example). The secondary argument has been to make it easy for kernel developers
> to work on both userspace and kernel in tandem (like has happened with vhost
> drivers). In short: it speeds up development of Linux virtualization code.

Why? You've made this statement over and over and over again, and I've
dismissed it over and over and over again because I simply don't think
it's true.

It's simply a statement with nothing to back it up. Why repeat it?

THAT is my main contention. I told you why I think it's actually
actively untrue. You claim it helps, but what is it about kvmtool that
makes it so magically helpful to be inside the kernel repository? What
is it about this that makes it so critical that you get the kernel and
kvmtool with a single pull, and they have to be in sync? When you then
at the same time claim that you make very sure that they don't have to
be in sync at all. See your earlier emails about how you claim to have
worked very hard to make sure they work across different versions.

So you make these unsubstantiated claims about how much easier it is,
and they make no sense. You never explain *why* it's so magically
easier. Is git so hard to use that you can't do "git pull" twice? And
why would you normally even *want* to do git pull twice? 99% of the
work in the kernel has nothing what-so-ever to do with kvmtool, and
hopefully the reverse is equally true.

And tying into the kernel just creates this myopic world of only
looking at the current kernel. What if somebody decides that they
actually want to try to boot Windows with kvmtool? What if somebody
tells you that they are really tired of Xen, and actually want to turn
kvmtool into  *replacement* for Xen instead? What if somebody wants to
branch off their own work, concentrating on some other issue entirely,
and wants to merge with upstream kvmtool but not worry about the
kernel, because they aren't working on the Linux kernel at all, and
their work is about something else?

I just don't think it makes sense. I don't see what the huge advantage
of a single git tree is.

Anyway, I'm done arguing. You can do what you want, but just stop
misrepresenting it as being "linux-next" material unless you are
willing to actually explain why it should be so.

                Linus
