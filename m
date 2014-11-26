Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaKZTM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:12:28 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61393 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaKZTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <547624C7.3020003@oracle.com>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
	<1417010419-3827-2-git-send-email-sasha.levin@oracle.com>
	<CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>
	<54761406.9090602@oracle.com>
	<CA+55aFz8TUtKtkPzQVHAS+-RfNmd6W=CQq4BRcEux+mf8tYtqw@mail.gmail.com>
	<547624C7.3020003@oracle.com>
Date: Wed, 26 Nov 2014 11:12:26 -0800
X-Google-Sender-Auth: 5R5tEVmfjC-3QWvoACTKSp6V3aI
Message-ID: <CA+55aFwCUyy3gF9M7JXuyRGgOzELVbPAe0T_7giqufgGCn3XKg@mail.gmail.com>
Subject: Re: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, mingo <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 11:06 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I'm pretty sure that this is something GCC will warn you about in the
> compilation stage.

It does? I've never seen it, but maybe it's a new thing.

The gcc signedness warnings have historically been so wretched that
it's just sad, and they have to be turned off.

> kernel/time/ntp.c:process_adjtimex_modes():
>
>         if (txc->modes & ADJ_FREQUENCY) {
>                 time_freq = txc->freq * PPM_SCALE;   <=== Undefined overflow
>                 time_freq = min(time_freq, MAXFREQ_SCALED);
>                 time_freq = max(time_freq, -MAXFREQ_SCALED);
>                 /* update pps_freq */
>                 pps_set_freq(time_freq);
>         }
>
> The multiplication is between signed integers, and it overflows (user triggerable).

Well, we check that the end result - overflowed or not - is in a sane
range. So this might fall under the heading of "user gets what he asks
for".

                         Linus
