Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaATWyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:54:15 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61862 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaATWyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:54:13 -0500
MIME-Version: 1.0
In-Reply-To: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
Date: Mon, 20 Jan 2014 14:54:12 -0800
X-Google-Sender-Auth: fOAv72MFJzWya0DHzpAFSrS_BrI
Message-ID: <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
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

So I pulled this, but one question:

On Mon, Jan 20, 2014 at 8:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> +config RANDOMIZE_BASE
> +       bool "Randomize the address of the kernel image"
> +       depends on RELOCATABLE
> +       depends on !HIBERNATION

How fundamental is that "!HIBERNATION" issue? Right now that
anti-dependency on hibernation support will mean that no distro kernel
will actually use the kernel address space randomization. Which
long-term is a problem.

I'm not sure HIBERNATION is really getting all that much use, but I
suspect distros would still want to support it.

Is it just a temporary "I wasn't able to make it work, need to get
some PM people involved", or is it something really fundamental?

            Linus
