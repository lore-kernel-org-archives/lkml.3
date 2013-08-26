Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3HZNwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:52:10 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59320 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3HZNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBbJMWox5yJaNzW_jUdDfKfWe-Y7d1riYdN6huQStxzcA@mail.gmail.com>
References: <CAJd=RBBbJMWox5yJaNzW_jUdDfKfWe-Y7d1riYdN6huQStxzcA@mail.gmail.com>
From: Michal Suchanek <hramrach@gmail.com>
Date: Mon, 26 Aug 2013 15:51:24 +0200
Message-ID: <CAOMqctQyS2SFraqJpzE0sRFcihFpMHRhT+3QuZhxft=SUXYVDw@mail.gmail.com>
Subject: Re: doing lots of disk writes causes oom killer to kill processes
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 March 2013 03:15, Hillf Danton <dhillf@gmail.com> wrote:
>>On 11 March 2013 13:15, Michal Suchanek <hramrach@gmail.com> wrote:
>>>On 8 February 2013 17:31, Michal Suchanek <hramrach@gmail.com> wrote:
>>> Hello,
>>>
>>> I am dealing with VM disk images and performing something like wiping
>>> free space to prepare image for compressing and storing on server or
>>> copying it to external USB disk causes
>>>
>>> 1) system lockup in order of a few tens of seconds when all CPU cores
>>> are 100% used by system and the machine is basicaly unusable
>>>
>>> 2) oom killer killing processes
>>>
>>> This all on system with 8G ram so there should be plenty space to work with.
>>>
>>> This happens with kernels 3.6.4 or 3.7.1
>>>
>>> With earlier kernel versions (some 3.0 or 3.2 kernels) this was not a
>>> problem even with less ram.
>>>
>>> I have  vm.swappiness = 0 set for a long  time already.
>>>
>>>
>>I did some testing with 3.7.1 and with swappiness as much as 75 the
>>kernel still causes all cores to loop somewhere in system when writing
>>lots of data to disk.
>>
>>With swappiness as much as 90 processes still get killed on large disk writes.
>>
>>Given that the max is 100 the interval in which mm works at all is
>>going to be very narrow, less than 10% of the paramater range. This is
>>a severe regression as is the cpu time consumed by the kernel.
>>
>>The io scheduler is the default cfq.
>>
>>If you have any idea what to try other than downgrading to an earlier
>>unaffected kernel I would like to hear.
>>
> Can you try commit 3cf23841b4b7(mm/vmscan.c: avoid possible
> deadlock caused by too_many_isolated())?
>
> Or try 3.8 and/or 3.9, additionally?
>

Hello,

with deadline IO scheduler I experience this issue less often but it
still happens.

I am on 3.9.6 Debian kernel so 3.8 did not fix this problem.

Do you have some idea what to log so that useful information about the
lockup is gathered?

Thanks

Michal
