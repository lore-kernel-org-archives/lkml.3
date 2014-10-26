Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaJZSQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:16:12 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:51697 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZSQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:16:11 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrU7NBCcAF6zYjY06SGQt=StNk5kUzUfexKF1CNVaD_o5Q@mail.gmail.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
	<CAFLxGvyLewqhMoHhyBmLdeN5GxOG_-THWBc5bVoG6jY+Pi07VQ@mail.gmail.com>
	<CALCETrU7NBCcAF6zYjY06SGQt=StNk5kUzUfexKF1CNVaD_o5Q@mail.gmail.com>
Date: Sun, 26 Oct 2014 11:16:10 -0700
X-Google-Sender-Auth: 37n0YiUxkTps2CKZXGX47CQTHyE
Message-ID: <CA+55aFyLcyvTqMvGKOQEW_v3UuMLsdcTpO_2B1sCW8aUTz67zw@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 4:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> On brief inspection, grsecurity isn't actually vmallocing the stack.
> It seems to be allocating it the normal way and then vmapping it.
> That allows it to modify sg_set_buf to work on stack addresses (sigh).

Perhaps more importantly, the vmalloc space is a limited resource (at
least on 32-bit), and using vmap probably results in less
fragmentation.

I don't think either is really even an option on 32-bit due to the
limited address space. On 64-bit, maybe a virtually remapped stack
would be ok.

                   Linus
