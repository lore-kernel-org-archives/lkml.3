Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3BKQdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:33:22 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:34264 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab3BKQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:33:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130211122654.GA5802@gmail.com>
References: <20130206214646.GA28135@gmail.com> <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com> <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com> <20130211122654.GA5802@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Feb 2013 08:32:59 -0800
X-Google-Sender-Auth: YQucneE3ucGk4fyTXjKPbZoipqA
Message-ID: <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
To: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 4:26 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> If you are asking whether it is critical for the kernel project
> to have tools/kvm/ integrated then it isn't. The kernel will
> live just fine without it, even if that decision is a mistake.

You go on to explain how this helps kvmtool, and quite frankly, I DO NOT CARE.

Everything you talk about is about helping your work, by making the
kernel maintenance be more. The fact that you want to use kernel
infrastructure in kvmtool is a great example: you may think it's a
great thing, but for the kernel it's just extra work, and extra layers
of abstraction etc etc.

And then you make it clear that you haven't even *bothered* to try to
make it a separate project.

Sorry, but with that kind of approach, I get less and less interested.
I think this whole tying together is a big mistake. It encourages
linkages that simply shouldn't be there.

And no, perf is not the perfect counter-example. With perf,. the
linkages made sense! There's supposed to be deep linkages to profiling
and event counting. There is ABSOLUTELY NOT supposed to be deep
linkages with virtualization. Quite the reverse.

And no, I don't want to maintain the mess that is both. There's just
no gain, and lots of potential pain.

                    Linus
