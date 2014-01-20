Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaATXMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:12:17 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61796 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaATXMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:12:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
Date: Mon, 20 Jan 2014 15:12:12 -0800
X-Google-Sender-Auth: CfE_ZXqW6BwGQ1IOSif5kSj1yI8
Message-ID: <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 2:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I pulled this, but one question:

.. oh, and since I decided to test it, and was looking for problems:
enabling kaslr breaks "perf". The *profile* looks fine, but the
disassembly doesn't work.

I'm not entirely surprised. I decided I wanted to test it for a
reason, after all. So it's not unexpected, but perhaps people hadn't
thought about it, and clearly hadn't tested it.

Kernel modules disassemble fine, so clearly perf knows about code that
moves around, but apparently it gets surprised when the core vmlinux
file disassembly doesn't match addresses.

             Linus
