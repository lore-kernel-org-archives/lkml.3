Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaIQFen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 01:34:43 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:59403 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaIQFel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 01:34:41 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
 <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
 <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com> <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Sep 2014 22:34:18 -0700
Message-ID: <CALCETrU0=_9voz1bxbLom=y7qnk7RN7U5Bd2s+Dk_QQN2yYVfw@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
To: Richard Larocque <rlarocque@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Filipe Brandenburger <filbranden@google.com>,
        Michael Davidson <md@google.com>, Greg Thelen <gthelen@google.com>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Sep 16, 2014 at 6:18 PM, Richard Larocque <rlarocque@google.com> wrote:
>> On Tue, Sep 16, 2014 at 5:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> I think that the patch should instead tweak the vvar mapping to tell
> the vdso not to use rdtsc.  It should be based on this:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vsyscall
>
> and I'll talk to hpa tomorrow about about getting that, or something
> like it, into the tip tree.  In particular, you'll need this:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vsyscall&id=0cc410a05cb95e073ebfe099c9e03cef48d2be0f

Crud.  Now that I've said that, I realize that this won't work right
if rdtscp is off.  I'll drop that patch.

I don't think that this changes the conclusion.  It should be possible
to swap out the vvar page to keep the vdso working even without rdtsc
available.

--Andy

>
> Also, this kind of inheritable restriction may end up requiring
> no_new_privs or CAP_SYS_ADMIN to be secure.
>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
