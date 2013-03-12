Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3CLCP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:15:56 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58591 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3CLCPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:15:43 -0400
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 10:15:43 +0800
Message-ID: <CAJd=RBBbJMWox5yJaNzW_jUdDfKfWe-Y7d1riYdN6huQStxzcA@mail.gmail.com>
Subject: Re: doing lots of disk writes causes oom killer to kill processes
From: Hillf Danton <dhillf@gmail.com>
To: Michal Suchanek <hramrach@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On 11 March 2013 13:15, Michal Suchanek <hramrach@gmail.com> wrote:
>>On 8 February 2013 17:31, Michal Suchanek <hramrach@gmail.com> wrote:
>> Hello,
>>
>> I am dealing with VM disk images and performing something like wiping
>> free space to prepare image for compressing and storing on server or
>> copying it to external USB disk causes
>>
>> 1) system lockup in order of a few tens of seconds when all CPU cores
>> are 100% used by system and the machine is basicaly unusable
>>
>> 2) oom killer killing processes
>>
>> This all on system with 8G ram so there should be plenty space to work with.
>>
>> This happens with kernels 3.6.4 or 3.7.1
>>
>> With earlier kernel versions (some 3.0 or 3.2 kernels) this was not a
>> problem even with less ram.
>>
>> I have  vm.swappiness = 0 set for a long  time already.
>>
>>
>I did some testing with 3.7.1 and with swappiness as much as 75 the
>kernel still causes all cores to loop somewhere in system when writing
>lots of data to disk.
>
>With swappiness as much as 90 processes still get killed on large disk writes.
>
>Given that the max is 100 the interval in which mm works at all is
>going to be very narrow, less than 10% of the paramater range. This is
>a severe regression as is the cpu time consumed by the kernel.
>
>The io scheduler is the default cfq.
>
>If you have any idea what to try other than downgrading to an earlier
>unaffected kernel I would like to hear.
>
Can you try commit 3cf23841b4b7(mm/vmscan.c: avoid possible
deadlock caused by too_many_isolated())?

Or try 3.8 and/or 3.9, additionally?

Hillf
