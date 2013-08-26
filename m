Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3HZSL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:11:26 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:45717 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3HZSLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu> <CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
 <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
 <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
 <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
 <20130823010726.GP27005@ZenIV.linux.org.uk> <20130825033741.GX27005@ZenIV.linux.org.uk>
 <CA+55aFxaKGcpdxKXK_axqyFz_oCvFm1Q=_fJLq8di97x_-cCig@mail.gmail.com>
 <20130825200605.GC27005@ZenIV.linux.org.uk> <CA+55aFyXq9kry7EtcnXOd_DWDVkDvVRWKLAfLOYHVsdY4RRJ8A@mail.gmail.com>
 <CA+55aFzcPFXei5j-i49+3kXZ5L9S-v66vrzU091EuXkSeg1G7A@mail.gmail.com> <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 Aug 2013 11:11:04 -0700
Message-ID: <CALCETrVVwWaQLL21u5y_c6cWN4QD75tm96DiJfxHQvvgbNDwNg@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Aug 26, 2013 at 10:37 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I'm playing with a patch that then in addition to the ptrace check
>> *also* requires that the file was opened with the same credentials as
>> the follower _or_ the task being followed. I'll see if that works out.
>
> Chrome sandboxing still _works_ with the attached patch, but there's a
> few audit messages about the sandbox being denied dac_read_search. And
> I'm really not very happy with this anyway.
>
> So I'm going to send it out (using email to archive things and see if
> anybody has any comments), and then forget about it.
>

I'm still not thrilled with this approach.  I'll see if I can find a
clean way to use fmode later today.

--Andy

>                   Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
