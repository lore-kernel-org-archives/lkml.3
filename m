Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3IYXEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:04:30 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43922 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3IYXE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <1380125886-10341-7-git-send-email-fweisbec@gmail.com>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	<1380125886-10341-7-git-send-email-fweisbec@gmail.com>
Date: Wed, 25 Sep 2013 16:04:28 -0700
X-Google-Sender-Auth: DDR9GdTAA3F-pdYiuin74T10CHg
Message-ID: <CA+55aFxDk9_cmo4SPYMgG_WQ+_g5e_v6O-HEtQ_nTs-q1zjykg@mail.gmail.com>
Subject: Re: [PATCH 6/7] irq: Optimize softirq stack selection in irq exit
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 9:18 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> +#ifdef __ARCH_IRQ_EXIT_ON_IRQ_STACK

Please don't introduce anymore of these insane ad-hoc crazy architecture macros.

Just make it a regular config option, which makes it much easier for
architectures to just select it at config time.

So make it something like CONFIG_IRQ_EXIT_ON_IRQ_STACK, and then
x86-64 (and now Power) can just do

    select IRQ_EXIT_ON_IRQ_STACK

in their arch/*/Kconfig files.

Basically, we really should strive to get rid of all those insane
[__]ARCH_xyzzy flags. We have too many of them, and they are insane.

              Linus
