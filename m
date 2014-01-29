Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaA2EJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:09:29 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:45726 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaA2EJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:09:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140128164320.GB7596@redhat.com>
References: <1390895840.8373.2.camel@beeld>
	<20140128164320.GB7596@redhat.com>
Date: Wed, 29 Jan 2014 10:09:26 +0600
Message-ID: <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
Subject: Re: Do we really need curr_target in signal_struct ?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/28, Rakib Mullick wrote:
>
> You could simply do while_each_thread(p, t) to find a thread which
> wants_signal(..).
>
Yes, while_each_thread() is much nicer than get_nr_thread(), thanks for
the pointer.

> But I guess ->curr_target was added exactly to avoid this loop if
> possible, assuming that wants_signal(->current_targer) should be
> likely true. Although perhaps this optimization is too simple.
>
Well, this code block will only hit when first check for wants_signal()
will miss, that means we need to find some other thread of the group.
AFAIU, ->current_target is only a loop breaker to avoid infinite loop,
but - by using while_each_thread() we can remove it completely, thus
helps to get rid from maintaining it too.

I'll prepare a proper patch with you suggestions for reviewing.

Thanks,
Rakib
