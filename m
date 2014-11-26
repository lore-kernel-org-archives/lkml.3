Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaKZT1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:27:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45656 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaKZT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:27:51 -0500
Message-ID: <547629B0.9020406@oracle.com>
Date: Wed, 26 Nov 2014 14:27:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrey Ryabinin <ryabinin.a.a@gmail.com>, mingo <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>	<1417010419-3827-2-git-send-email-sasha.levin@oracle.com>	<CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>	<54761406.9090602@oracle.com>	<CA+55aFz8TUtKtkPzQVHAS+-RfNmd6W=CQq4BRcEux+mf8tYtqw@mail.gmail.com>	<547624C7.3020003@oracle.com> <CA+55aFwCUyy3gF9M7JXuyRGgOzELVbPAe0T_7giqufgGCn3XKg@mail.gmail.com>
In-Reply-To: <CA+55aFwCUyy3gF9M7JXuyRGgOzELVbPAe0T_7giqufgGCn3XKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 02:12 PM, Linus Torvalds wrote:
>> kernel/time/ntp.c:process_adjtimex_modes():
>> >
>> >         if (txc->modes & ADJ_FREQUENCY) {
>> >                 time_freq = txc->freq * PPM_SCALE;   <=== Undefined overflow
>> >                 time_freq = min(time_freq, MAXFREQ_SCALED);
>> >                 time_freq = max(time_freq, -MAXFREQ_SCALED);
>> >                 /* update pps_freq */
>> >                 pps_set_freq(time_freq);
>> >         }
>> >
>> > The multiplication is between signed integers, and it overflows (user triggerable).
> Well, we check that the end result - overflowed or not - is in a sane
> range. So this might fall under the heading of "user gets what he asks
> for".

I guess, though it wouldn't be clear to the user why it's broken since he passed a
seemingly valid looking value for txc->freq.


Thanks,
Sasha
