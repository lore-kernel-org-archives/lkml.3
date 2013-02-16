Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3BPTvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 14:51:25 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:50413 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3BPTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 14:51:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVnBeNEOgH4b+=FywMCnR-u7afADXK2KaiU+aSR+UcDYw@mail.gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com> <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos> <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com> <20130214150810.GA26095@gmail.com>
 <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
 <20130215114425.GD26955@gmail.com> <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
 <CAE9FiQVnBeNEOgH4b+=FywMCnR-u7afADXK2KaiU+aSR+UcDYw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Feb 2013 11:51:03 -0800
X-Google-Sender-Auth: SA466uGPDax-68C1BwNl1Ea6tlU
Message-ID: <CA+55aFwL3+sk4LkwgoV53Qe_F=EkA79mvpRY5ssBopyqiJCf9Q@mail.gmail.com>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 11:38 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> but you forgot to update setup_usemap() for SPARSEMEM

Heh. I tried desperately to find a config to test my patch in, because
I couldn't see how to even disable SPARSEMEM for my normal x86-64
build. But then I *only* tested it for that non-SPARSEMEM case,
expecting that to be what showed any problems. The fact that I didn't
bother testing my normal config is a bit ironic.

But I'd still like verification that it actually fixes Ingo's issue.
It *looks* like it should, and it would explain the potential for
memory corruption, but perhaps Ingo's odd lock-up is due to something
really subtle and unrelated to the actual allocation size.

                Linus
