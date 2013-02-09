Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3BIAqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:46:13 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58931 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab3BIAqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
 <20130204184436.GA13256@gmail.com> <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com> <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
 <20130206214646.GA28135@gmail.com> <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com> <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Feb 2013 11:45:50 +1100
X-Google-Sender-Auth: RDNiamiJ1WqohNCkl8yEHv9Kcko
Message-ID: <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Rientjes <rientjes@google.com>,
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

On Sat, Feb 9, 2013 at 10:57 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> And yes, you are absolutely correct that living in the kernel tree is
> suboptimal for the casual user. However, it's a trade-off to make
> tools/kvm *development* easier especially when you need to touch both
> kernel and userspace code.

Quite frankly, that's just optimizing for the wrong case.

The merged case seems to make sense for you and Ingo, and nobody else.

And then you wonder why nobody else wants to merge it.

I've told you my reasons, you didn't give me *any* actual reasons for
me to merge the code. NONE of your statements made any sense at all,
since everything you talk about could have been done with a separate
project.

The only thing the lock-step does is to generate the kind of
dependency that I ABSOLUTELY DETEST, where one version of kvmtools
goes along with one version of the kernel. That's a huge disadvantage
(and we've actually seen signs of that in the perf tool too, where old
versions of the tools have been broken, because the people working on
them have been way too much in lock-step with the kernel it is used
on).

And if it's not the case that they have to be used in lockstep, then
clearly kvmtool developers could just as easily just have a separate
git repository.

So you can't have it both ways. What's so wrong with just making it a
separate project?

                  Linus
