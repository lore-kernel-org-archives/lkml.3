Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbaETVo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:44:29 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:60223 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETVo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:44:28 -0400
MIME-Version: 1.0
In-Reply-To: <fcf01c888d8c59672aea60bf766d0d01.squirrel@www.luminoussheep.net>
References: <42308d5cdecee35097f0ac8ae3a0fbe8.squirrel@www.luminoussheep.net>
	<aa949b75ae938371ecd3bd5b35577bca.squirrel@www.luminoussheep.net>
	<CALYGNiM0hqDmD2wKVu8rA1Y3UUgYQ+Ho2V_HG0wxNgdzDNWdFg@mail.gmail.com>
	<fcf01c888d8c59672aea60bf766d0d01.squirrel@www.luminoussheep.net>
Date: Wed, 21 May 2014 01:44:27 +0400
Message-ID: <CALYGNiPqcFxZp_WJYx4XV8TWkvsjs3XihSqLeP1=ZHU3xqrmOw@mail.gmail.com>
Subject: Re: General protection fault - bug report 3.12.18
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Martin <martin@luminoussheep.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:40 PM, Martin <martin@luminoussheep.net> wrote:
>> I've looked into second crash. Just because gmail has marked that
>> email as important for some reason =)
>>
>> In function tid_fd_revalidate(), in line "file = fcheck_files(files,
>> fd)" file = is 0x0000000004000000 instead of valid pointer or NULL.
>> This value has only one non-zero bit, so this looks like memory
>> curruption.
>>
>> More likely this is hardware problem. Please check you memory with
>> memtest86 and/or try to replace it.
>
> Many thanks for looking into this, I was a bit worried that would be the
> answer as I've seen other crashes in what seem like random places.
>
> I already ran memtest86+ and it ran clean overnight and all day, so I
> thought it might just be a kernel bug still.
>
> Any other ideas how I could prove it to be a hardware issue?

I guess, only by replacing pieces.
As I see this is Lenovo Yoga2, this reminds me recent problems in
their firmware in T540 (or so).

You could run user-space memory tester like "memtester" in backround
while linux works.
Maybe it could catch that memory corruption. Probably it appears only
in particular situation.

>
> Regards,
> M
>
>
>
