Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaBMELw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:11:52 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34386 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBMELu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:11:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAKbGBLgs9t4HPD4duBt=vPaw0WfxLv5qr6pNupHsPTFaV5m+dQ@mail.gmail.com>
References: <20131012171007.GA17167@gmail.com>
	<CAKbGBLgs9t4HPD4duBt=vPaw0WfxLv5qr6pNupHsPTFaV5m+dQ@mail.gmail.com>
Date: Wed, 12 Feb 2014 20:11:49 -0800
X-Google-Sender-Auth: tyz2X4K_t_iX4I7OPMlpLb8pp_c
Message-ID: <CA+55aFys_VK+q3LMRzEM-AKU-=fM_tgiDdLm2AO=jVfH7OvrHQ@mail.gmail.com>
Subject: Re: [GIT PULL] compiler/gcc4: Add quirk for 'asm goto' miscompilation bug
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jakub Jelinek <jakub@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 7:09 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>
> If I change the GCC_VERSION check for the asm_volatile_goto quirk to
> include 4.8.2, then KVM guests are properly cleaned up.

Ok, I guess that means we should just make the quirk unconditional.

Ingo, do you want to do that or should I?

> So is there some other 'asm goto' bug we haven't yet fully uncovered
> and reported to GCC upstream?

Not to my knowledge. But I'm sure Jakub&co would love to have a test-case.

Sadly, gcc has that really annoying habit of making small changes
create *huge* changes in label numbers etc, and that's definitely the
case with the extra empty asm - it's basically impossible to compare
the generated asm with and without the workaround, because all the
label numbers change.

I have no idea how gcc people debug things like this, when the output
is so unstable.

Jakub, any suggestions to how Steven might be able to pinpoint where
the code generation problem lies?

                Linus
