Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3H2Aa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:30:26 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:61879 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3H2AaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <87sixt735b.fsf@xmission.com>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<871u5gqtw3.fsf@xmission.com>
	<20130826172054.GE27005@ZenIV.linux.org.uk>
	<20130827172406.GA2664@dztty>
	<20130828201141.GA21455@dztty>
	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
	<20130828211116.GA22184@dztty>
	<87sixt735b.fsf@xmission.com>
Date: Wed, 28 Aug 2013 17:30:25 -0700
X-Google-Sender-Auth: Qsr0kAgQrRqrrrtQPGJoeseF4Lk
Message-ID: <CAGXu5jLD+wFpaDW=Zr0gMj-8FqZtD4=UXekrjJS4py_uD7YgUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Solar Designer <solar@openwall.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 5:26 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Can someome please state what they are worried about in simple language
> step by step?
> [...]
> The closest I saw in the thread was people were worried about ASLR being
> defeated.  All I see are kernel addresses and we don't have much if any
> runtime or even load time randomization of where code is located in the
> kernel address map on x86_64.  So I don't understand the concern.

I showed the output of "syscall", since that contains user-space
addresses and shows a leak of ASLR from a privileged process to an
unprivileged process.

The flaw as I see it is that an unprivileged process opens
/proc/$priv_pid/syscall and passes it to a setuid process which is
able to read it, and provides those contents to the unprivileged
process.

The unprivileged process should not be able to the open the file in
the first place.

-Kees

-- 
Kees Cook
Chrome OS Security
