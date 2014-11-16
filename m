Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbaKPUoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:44:55 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59643 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaKPUox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:44:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAAMCDedJnXjF+3c5vXOKsZDqk0FgBODs9zX18guuGZNKh+QSsw@mail.gmail.com>
References: <CAD6G_RREb58La-pC48BHW+9r9oruUXnCrk-RS8LaKSw6y9jgxg@mail.gmail.com>
	<CAAMCDec3EJ4e=bDKwH3i0PL655yrOQkBu_typihYMGD3GHZiQA@mail.gmail.com>
	<CAD6G_RSiyhD2zSxEAGY_uFz3cjHtsRb+riF9EhziA78AwqvpwA@mail.gmail.com>
	<CAAMCDedJnXjF+3c5vXOKsZDqk0FgBODs9zX18guuGZNKh+QSsw@mail.gmail.com>
Date: Mon, 17 Nov 2014 02:14:52 +0530
Message-ID: <CAD6G_RRs7tqkHbKDErrF7dvmJqk1vLyo1-hK_=hUS6R4M=f4Dw@mail.gmail.com>
Subject: Re: read performance is too low compared to write - /dev/sda1
From: Jagan Teki <jagannadh.teki@gmail.com>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, davem <davem@davemloft.net>,
        linux-ide <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2014 19:22, Roger Heflin <rogerheflin@gmail.com> wrote:
> What kind of underlying disk is it?

GEN3 Sata link, SSD from Samsung.

>
> On Fri, Nov 14, 2014 at 7:36 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>> On 14 November 2014 18:50, Roger Heflin <rogerheflin@gmail.com> wrote:
>>> If you are robocoping small files you will hit other limits.
>>>
>>> Best I have seen with small files is around 30 files/second, and that
>>> involves multiple copies going on.   Remember with a small files there
>>> are several reads and writes that need to be done to complete a create
>>> of a small file and each of these take time.    30 files/second ~ 30ms
>>> per file, not that bad considering that on a real spinning disk a
>>> single read/write op is 5-10ms, and creating the file entry, copying
>>> data and closing the file takes several operations (at least create
>>> file entry, write small amount of data, update file entry
>>> date/time/info).     If the write in the middle is not a significant
>>> amount of data, the 2 extra ops are what hurts.
>>>
>>
>> But, I tried 4gb and 1gb files both got a similar numbers.
>>
>>> On Fri, Nov 14, 2014 at 6:55 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I'm doing a performance testing on my bench ARM box.
>>>>
>>>> 1. dd test: I have validate the read and write by mounting /dev/sda1
>>>> with ext4 filesystem,
>>>>     able to get the good performance numbers where read is high
>>>> compared to write
>>>>
>>>> 2.  robocopy test:
>>>>      - mkfs.ext4 /dev/sda1
>>>>      - mount /dev/sda1 /media/disk
>>>>      - << configured samba >>
>>>>      - Mapped the /media/disk on windows
>>>>      - login on the mapped driver in windows
>>>>      - did a robocopy test, where write got 84MBps and read 14MBps
>>>>
>>>> read performance is too slow when compared to write in robocopy case.
>>>> Can anyone help me out, how to debug this further.
>>
>> thanks!
>> --
>> Jagan.



-- 
Jagan.
