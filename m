Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3K0L1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:27:37 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55245 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3K0L1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:27:36 -0500
Date: Wed, 27 Nov 2013 12:27:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olofj@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] use -fstack-protector-strong
Message-ID: <20131127112731.GA10435@gmail.com>
References: <20131126203727.GA352@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126203727.GA352@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> On a defconfig x86_64 build (with CONFIG_CC_STACKPROTECTOR enabled), the
> delta in size is just under 9% larger:
> 
>  -rwxrwxr-x 1 kees kees  22134340 Nov 26 10:28 vmlinux.gcc-4.8
>  -rwxrwxr-x 1 kees kees  22123870 Nov 26 10:40 vmlinux.gcc-4.9
>  -rwxrwxr-x 1 kees kees  24225118 Nov 26 10:42 vmlinux.gcc-4.9+strong

Please run it through 'size' so that we know the real text size 
increases.

If the cost of -fstack-protector-strong is really +9% in kernel text 
size then that's rather significant!

If this option blows up our performance critical codepaths as well 
then this will likely cause a runtime slowdown as well, in addition to 
the increase in I$ footprint. That needs to be measured.

CONFIG_CC_STACKPROTECTOR=y is relatively cheap today. For example on 
x86-64 defconfig:

      text    data    bss     dec       filename
  11378972    1455056 1191936 14025964  vmlinux  # CONFIG_CC_STACKPROTECTOR is not set
  11420243    1455056 1191936 14067235  vmlinux  CONFIG_CC_STACKPROTECTOR=y

that's a +0.3% cost currently.

Thanks,

	Ingo
