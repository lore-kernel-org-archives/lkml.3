Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaLCCWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:22:36 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49940 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaLCCWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:22:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141202170037.GG29748@ZenIV.linux.org.uk>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<20141202170037.GG29748@ZenIV.linux.org.uk>
Date: Wed, 3 Dec 2014 13:22:33 +1100
Message-ID: <CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Alex Dubov <alex.dubov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 4:00 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Dec 02, 2014 at 03:35:18PM +1100, Alex Dubov wrote:
>> +
>> +     if (rc < 0)
>> +             __close_fd(dst_files, s_info.si_int);
>
> Oh, lovely...  And we are guaranteed that it still the same file, because...?
>
> Not to mention anything else, this stuff violates the assumption used in a lot
> of places - that the *only* way for a process to modify a descriptor table is
> to have a reference to it obtained by something that had it as its current
> descriptor table and not dropped since then.  The way you do it might actually
> turn out to be OK, but there's no way I'll take that without detailed analysis;
> start with refcounting of struct file, for one thing - it does rely on the
> assumption above in non-trivial ways.

Ok, I see the problem here. This indeed requires further thought.

> And that's aside of the points other folks had brought up.

Yours is the first insightful message in this thread. Some of the
other commenters exhibited an unfortunate lack of understanding,
regarding what signals are and what they can be useful for.

Unless, of course, I have missed something important.

On a less related note, I hope you will agree that the simpler
mechanism for this very in-demand feature is long overdue on Linux
(every man and his dog are passing fds around these days).
