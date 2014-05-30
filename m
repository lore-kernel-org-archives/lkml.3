Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbaE3UBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:01:10 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49956 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaE3UBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <538658EE.8030809@zytor.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
 <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
 <538658EE.8030809@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 May 2014 13:00:46 -0700
Message-ID: <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
Subject: Re: Pondering per-process vsyscall disablement
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marian Marinov <mm@1h.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 2:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/23/2014 09:40 AM, Andy Lutomirski wrote:
>>
>> I don't think this should be something configured by the
>> administrator, unless the administrator is the builder of a kiosky
>> thing like Chromium OS.  In that case, the administrator can use
>> vsyscall=none.
>>
>> I think this should be handled by either libc or the toolchain, hence
>> the suggestions of a syscall or an ELF header.
>>
>
> We could mimic the NX stack stuff, but it would have a lot of false
> negatives, simply because very few things would actually poke at the
> vsyscall page.
>
> The NX stuff uses a dummy program header in the ELF image.
>
> On the other hand, you could make the argument that anything compiled
> with a new toolchain simply should not use the vsyscall page, and just
> unconditionally set the opt-out bit (header) in question.
>
> It might be better to have some kind of flags field (which a number of
> architectures use) than keep using dummy program headers, though.

Do the flags go in the ELF loader or in the executable we're running?
Or both (and, if both, do we and them or or them)?

I think the interpreter makes a little more sense in general: for the
most part, use of vsyscalls is a property of the runtime environment,
not of the program being run.  But maybe this is naive.

--Andy
