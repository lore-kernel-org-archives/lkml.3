Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947209Ab3BHVPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:15:07 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:34659 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947139Ab3BHVPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:15:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130208145539.GC30334@gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
 <20130204184436.GA13256@gmail.com> <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com> <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
 <20130206214646.GA28135@gmail.com> <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Feb 2013 08:14:43 +1100
X-Google-Sender-Auth: k_VEOy1s4QdgAnYwIRfCtgmy8Hg
Message-ID: <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 1:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I'll remove it if Linus insists on it, but I think you guys are
> putting form before substance and utility :-(

No. Your pull requests are just illogical. I have yet to see a single
reason why it should be merged.

I *thought* "ease of use" could be a reason, and then people posted
five-liner scripts to give some of the other virtual boxes the same
kind of interface.

Avoiding five lines of shell script is not a reason to pull a project
into the kernel.

> tools/kvm/ is a useful utility to kernel development, that in
> just this past cycle was used as an incubator to:

That's total bullshit.

It could be useful whether it is merged into the kernel or not.

"git" is a hell of a lot more useful utility for kernel development,
to the point that practically we couldn't do without it any more, and
it isn't merged into the kernel. It's a separate project with a
separate life, and it is *better* for it. The same goes for all the
tools that everybody uses every day for kernel development, often
without even thinking about them.

So "utility to kernel development" is not a reason for merging it into
the kernel. NOT AT ALL.

> *Please* don't try to harm useful code just for the heck of it.

Again, total *bullshit*. Right now, the whole "attach the kvmtool to
the kernel as a remora" doesn't make any sense at all, and not merging
it doesn't harm anything AT ALL. Quite the reverse.

The fact that kvmtool isn't available as a standalone project probably
keeps people actively from using it. You can't just fetch kvmtool. You
have to fetch the kernel and kvmtool, and if you're a kernel developer
you either have to make a whole new kernel tree for it (which is
stupid) or merge it into your normal kernel tree that has development
that has nothing to do with kvmtool (which is stupid AND F*CKING
INSANE)

> Please stop this silliness, IMO it's not constructive at all ...

Ingo, it's not us being silly, it is *you*.

What the heck is the advantage of merging it into the kernel? It has
never ever been explained.

This is not like "perf", where there wasn't any alternatives, and
oprofile had shown over many many years that the situation wasn't
improving: it was only getting worse, and more disconnected from the
actual capabilities of the hardware.

But kvmtool is no "perf". There are other virtual boxes, and rather
than being limited, they are more capable! The selling tool of kvmtool
was never that it did something particularly magical, it was always
that it did less, and was easier to use. But that does not in any way
mean "should be merged". You can do less and be easier to use and
stand on your own legs.

So here, let me state it very very clearly: I will not be merging
kvmtool. It's not about "useful code". It's not about the project
keeping to improve. Both of those would seem to be *better* outside
the kernel, where there isn't that artificial and actually harmful
tie-in.

In other words, I don't see *any* advantage to merging kvmtool. I
think merging it would be an active mistake, and would just tie two
projects together that just shouldn't be tied together.

So nobody is "hurting useful code", except perhaps you.

Explain to me why I'm wrong. I don't think you can. You certainly
haven't so far.

               Linus
