Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796Ab3BISII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 13:08:08 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:60703 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760774Ab3BISIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 13:08:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
 <20130204184436.GA13256@gmail.com> <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com> <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
 <20130206214646.GA28135@gmail.com> <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com> <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com> <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 10 Feb 2013 05:07:45 +1100
X-Google-Sender-Auth: evuUzAvnzXavvBmcQHYPh_k2y6I
Message-ID: <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
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

You do realize that none of your arguments touched the "why should
Linus merge the tree" question at all?

Everything you said was about how it's more convenient for you and
Ingo, not at all about why it should be better for anybody else. You
haven't bothered to even try making it an external project, so it
doesn't compile that way. You're the only one working on it, so being
convenient for you is the primary issue. Arguments like that actively
make me not want to merge it, because they are only arguments for you
continuing to work the way you have, not arguments for why the project
would make sense to merge into the main kernel repository.

So I think we should just remove this from linux-next, and be done
with the fantasy that it makes sense to merge this. You're not even
trying to convince anybody else about the merge making sense.

You might as well continue to work the way you do, and I don't mind -
but none of it argues for me merging it into the kernel. There's no
reason why kvmtool couldn't be external the way all the other
virtualization projects are.

             Linus

On Feb 9, 2013 2:01 AM, "Pekka Enberg" <penberg@kernel.org> wrote:
>
> On Sat, Feb 9, 2013 at 2:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Quite frankly, that's just optimizing for the wrong case.
>
> I obviously don't agree. I'm fairly sure there wouldn't be a kvmtool
> that supports x86, PPC64, ARM, and all the virtio drivers had we not
> optimized for making development for kernel folks easy.
>
> In fact that's something Ingo pushed for pretty hard early on and we
> also worked hard just to make the code 'feel familiar' to kernel folks.
> The assumption was that if we did that, we'd see contributions from
> people who would normally not write userspace code.
>
> On Sat, Feb 9, 2013 at 2:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > The merged case seems to make sense for you and Ingo, and nobody else.
>
> That's hardly surprising. I'm the only person who was crazy enough to
> listen to Ingo and follow through with the damn thing. So I either have
> the same experience and perspective as Ingo does on the matter - or I'm
> just as full of 'bullshit' as he is.
>
> On Sat, Feb 9, 2013 at 2:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > The only thing the lock-step does is to generate the kind of
> > dependency that I ABSOLUTELY DETEST, where one version of kvmtools
> > goes along with one version of the kernel.
>
> That is simply NOT TRUE. We have never done such a thing with 'kvmtool'
> nor I have any evidence that 'perf' has done that either. I regularily
> run old versions to make sure that we stay that way.
>
> On Sat, Feb 9, 2013 at 2:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > So you can't have it both ways. What's so wrong with just making it a
> > separate project?
>
> Do you really think it's an option I have not considered several times?
>
> There are the immediate practical problems:
>
>   - What code should we take with us from the Linux repository. If I take
>     just tools/kvm, it won't even build.
>
>   - Where do we do our development? Right now we are using the KVM list
>     and are part of tip tree workflow. As a separate project, we need to
>     build the kind of infrastructure we already are relying on now.
>
> Then there are the long term issues:
>
>   - How do we keep up with KVM and virtio improvements?
>
>   - How do we ensure we get improvements that happened in the kernel
>     tree to our codebase for the code we share?
>
>   - How do we make it easy for future KVM and virtio developers to
>     access our code?
>
> If you want perspective on this just ask Ingo sometime how he feels
> about making tools/perf a separate project (which I have actually done).
> Much of the *practical* aspects applies to tools/kvm.
>
> And really, I'm a practical kind of guy. Why do you think I'm willing to
> bang to my head to the wall if spinning off as a separate project would
> be as simple as you seem to think it is?
>
>                         Pekka
