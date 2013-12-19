Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3LSVZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:25:08 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:59486 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3LSVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:25:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131219211406.GA3464@gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
	<tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
	<20131219204051.GA2253@gmail.com>
	<CA+55aFyr5VcONQKp_yDRDy+BFpMy9=P--+U8d1uYeDVNWcAM8Q@mail.gmail.com>
	<20131219211406.GA3464@gmail.com>
Date: Fri, 20 Dec 2013 06:25:05 +0900
X-Google-Sender-Auth: MReELVJNBkabvN7NLq8O8hRaZPU
Message-ID: <CA+55aFzRUBrMUgFsJ6tfPrH2k_9gEqwUFEHvJZUz6o+Tf4QSoA@mail.gmail.com>
Subject: Re: [tip:x86/idle] x86, idle: Use static_cpu_has() for CLFLUSH
 workaround, add barriers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@linux.intel.com>, Len Brown <len.brown@intel.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 6:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> So, my thinking was that maybe it's the other way around: the problem
> is with the write not being drained to cache yet.

That is possible. I haven't seen the exact details of the monitor
errata . If it's just about the write buffer and cache interaction,
then I agree that the barrier after the write in
current_set_polling_and_test() is sufficient.  But in the absense of
knowledge, I think we should have it after the read too.

              Linus
