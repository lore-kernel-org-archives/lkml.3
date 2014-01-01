Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaAAAQG (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 19:16:06 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51147 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbaAAAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 19:16:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>
	<tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
	<alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
	<CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>
Date: Tue, 31 Dec 2013 16:16:01 -0800
X-Google-Sender-Auth: w1hVWA0guQq0p2qjhxxiWD731RU
Message-ID: <CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when
 compiler lacks support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>, Shawn Guo <shawn.guo@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 4:45 PM, Kees Cook <keescook@chromium.org> wrote:
>
> NAK. If you have selected CONFIG_CC_STACKPROTECTOR_STRONG, the build
> the fail hard. Without this, it means you'll end up with kernels that
> build and show a stackprotector option in their config, which is
> false.

What we really really want to do is to have some way to add config
options based on shell scripts and compiler support. That would also
get rid of a lot of Makefile trickery etc.

Then we could just make CC_STACKPROTECTOR_STRONG depend on
CC_SUPPORTS_STACKPROTECTOR_STRONG or whatever.

                Linus
