Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaISWT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:19:27 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50451 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaISWTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXOeD=zBPvYV+-j0Ok6MXNZwdjRaz73rjuLGShx+o6Y0w@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
	<CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
	<54194A4A.7030104@zytor.com>
	<CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
	<CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com>
	<CADU+-uBMc9THr0ADntsOqwh1--ULYMcssgPBvTesvFR+KQUfRg@mail.gmail.com>
	<CALCETrXOeD=zBPvYV+-j0Ok6MXNZwdjRaz73rjuLGShx+o6Y0w@mail.gmail.com>
Date: Fri, 19 Sep 2014 15:19:24 -0700
Message-ID: <CADU+-uBmQdKSX==5NrYfSEWLg-X4cvJYXj=N8UdMdN_rHnWk4w@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
From: Filipe Brandenburger <filbranden@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg Thelen <gthelen@google.com>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Davidson <md@google.com>, Ingo Molnar <mingo@redhat.com>,
        Richard Larocque <rlarocque@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 19, 2014 at 3:09 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Sep 19, 2014 at 3:02 PM, Filipe Brandenburger <filbranden@google.com> wrote:
>> In case that's useful, I was looking at swapping the vvar page by
>> changing the vm_special_mapping to change the pages array between the
>> actual vvar page and the zero page and using zap_page_range to force
>> the next access to go through a page fault that would remap it.
>
> That will do it globally, since the vm_special_mapping is global.  I
> was just thinking of using remap_pfn_range.

Sorry if I wasn't clear... That's the exact point of my patch, to make
vm_special_mapping local to the task.

I started with an approach of keeping a struct vm_special_mapping + a
struct page * array per mm_struct.

I was also looking at keeping two static vm_special_mapping structs,
one with the actual vvar page and the other with the zero page and
then swapping vma->vm_private_data to point to the appropriate one.

> Give me another day or two to straighten out the vma stuff, although
> it shouldn't impact your patches too much.  The main effect will be
> that you'll be able to rely on mm->context.vdso (renamed to
> vvar_vma_start, most likey) being correct.  Currently, you should
> *not* rely on it, especially if CRIU is involved.

Cool! As I said, let me know if you'd like to see some of my
incomplete patches or if you'd like me to keep working on them to show
you something more complete.

Cheers,
Filipe
