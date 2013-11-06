Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3KFAll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:41:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42363 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFAlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:41:39 -0500
Date: Wed, 6 Nov 2013 00:40:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Paul Moore <paul@paul-moore.com>,
        Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
Message-ID: <20131106004058.GU16735@n2100.arm.linux.org.uk>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com> <CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 04:14:49PM -0800, Kees Cook wrote:
> I would agree: option 1 seems cleanest of the 3. 3 is sort of like a
> built-in automatic check for a mismatched arch, so maybe that works
> better?
> 
> Alternatively, CONFIG_SECCOMP_FILTER could depend on
> !CONFIG_OABI_COMPAT. That seems like the least work, given the desire
> to kill OABI in the real world. (Though I would note that at least
> Ubuntu's ARM kernels build with CONFIG_OABI_COMPAT; Chrome OS does
> not.)

OABI compat is really only something you want to deal with if you have
a reason to run OABI programs on the kernel; it is in no way guaranteed
that the OABI programs will run properly (many ALSA programs will not
because of different layouts with ioctls).

OABI compat was meant to allow a transition from OABI to EABI.  While
a lot of effort went in to the kernel side of that, which does allow
OABI based userspace to boot with an EABI kernel, and allows OABI built
test programs to run under an EABI kernel, actually being able to
migrate userland is far from trivial - and something that I've never
been able to do.  Hence, virtually all my long-running ARM machines
here are stuck with OABI, and I don't see that situation ever changing.

As a rule, distros should not be enabling OABI compat.  OABI compat
is more something that a developer (like me) who has a reason to enable
it turns it on.
