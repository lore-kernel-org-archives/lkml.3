Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaETG5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:57:00 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:40042 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaETG46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:56:58 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140519154639.5570a30f8b47872a323dcdfd@linux-foundation.org>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-2-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-3-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-4-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-5-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-6-git-send-email-manfred@colorfullife.com>
 <1400399917-17583-7-git-send-email-manfred@colorfullife.com> <20140519154639.5570a30f8b47872a323dcdfd@linux-foundation.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 20 May 2014 08:56:38 +0200
Message-ID: <CAKgNAkhhqzA5twBAXWGJc1h59EDXXZz+CjgCsxAbVrGowt6jig@mail.gmail.com>
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, 1vier1@web.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:46 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 18 May 2014 09:58:37 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:
>
>> SUSv4 clearly defines how semncnt and semzcnt must be calculated:
>> A task waits on exactly one semaphore:
>> The semaphore from the first operation in the sop array that cannot proceed.
>>
>> The Linux implementation never followed the standard, it tried to count all
>> semaphores that might be the reason why a task sleeps.
>>
>> This patch fixes that.
>
> What are the back-compatibility implications of this change?

Hard to estimate, but some thoughts:
* These operations seem to be very little used. Grepping the public
  source that is contained Fedora 20 source DVD, there appear
  to be no uses. Of course, this says nothing about uses in
  private / non-mainstream FOSS code, but it seems likely that
  the same pattern is followed there.
* The existing behavior is hard enough to understand that I suspect that
  no one understood it well enough to rely on it anyway (especially as
  that behavior contradicted both man page and POSIX).

So, there's a chance of breakage, but I estimate that it's minute.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
