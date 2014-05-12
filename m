Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaELICh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:02:37 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45716 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaELICc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:02:32 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 12 May 2014 10:02:12 +0200
Message-ID: <CAKgNAkiLwFrn=kDSrc4JSfobaM98pLVMcrCy4EoobgeXjqfK0g@mail.gmail.com>
Subject: Re: [PATCH 0/6] ipc/sem.c: Fix semctl(,,{GETNCNT,GETZCNT})
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

On Sat, May 10, 2014 at 12:03 PM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> Hi all,
>
> According to the man page of semop(), semzcnt or semncnt are increased
> exactly for the operation that couldn't proceed.

Perhaps it's woth noting here that the man page is also pretty close
to the POSIX text that describes semzcnt and semncnt. Form the SUSv4
<sys/sem.h> spec:

semncnt: number of processes waiting for semval to become
        greater than current value.
semzcnt: Number of processes waiting for semval to become 0.

> The Linux implementation always tried to be clever and to increase the counters
> for all operations that might be the reason why a task sleeps.
>
> The following patches fix that and make the code conform to the
> documentation.
>
> The series got fairly long, because I also noticed that semzcnt was calculated
> incorrectly.
>
> What do you think?
> I ran a few test cases, and the semncnt and semzcnt counts now match
> the expectation.

Are any of those test cases in a form that could be used by other to
replicate your results? Also, are there any of those tests that could
go into the source tree?

> Is anyone aware of an application that uses GETNCNT or GETZCNT?

FWIW, grepping the C/CC++ sources from the Fedora 20 source DVD turns
up no uses, AFAICS. Obviously, this tells us nothing about "private"
users that may be out there, such as the Oracle case that Davidlohr
alluded to.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
