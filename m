Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaLJTdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:33:14 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55283 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaLJTdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:33:13 -0500
Message-ID: <54889FF6.2000508@hurleysoftware.com>
Date: Wed, 10 Dec 2014 14:33:10 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, Denis Du <dudenis2000@yahoo.ca>,
        gregkh@linuxfoundation.org, jmmahler@gmail.com
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TTY: Fix the missing lock for the TTY ldisc buffer
References: <5488931C.4040308@yahoo.ca> <548895D9.6090402@suse.cz>
In-Reply-To: <548895D9.6090402@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 01:50 PM, Jiri Slaby wrote:
> On 12/10/2014, 07:38 PM, Denis Du wrote:
>>
>> Hi, Guys:
> 
> Hi, are you sending this using some robot? I think I have seen like ten
> copies of this patch already.
> 
>> It was found that the 3.12 kernel tty layer will lose or corrupt data
>> when have a full-duplex communication, especially in high baud rate, for
>> example 230k for my OMAP5 uart. Eventually I found there is lock missing
>> between copy data to ldisc layer buffer and copy data from the same
>> buffer to user space. I believe this issue existed since 3.8
>> kernel(since this kernel , it start to remove most of the spin-locks)
>> and I didn't find any fix even through 3.17 kernel. This patch was
>> tested to be works great with no any data loss again on 3.12 kernel.
>>
>> This patch was built for the latest kernel, but I cannot test it.
>> Somebody may give a test.
>>
>> I did try to use the existed lock atomic_read_lock, but it doesn’t work.
> 
> Anyway, adding Peter Hurley to CC who was working on eliminating locks
> from this code lately. More precisely since 3.12 we have no locks there,
> which would explain why are you seeing it starting 3.12.

Yeah, sorry. A new version of gcc for ARM exposed the lack of barriers for
the head pointer in raw mode. I got tied up on something else, but this
is my #1 priority now.

I hope to have something testable in the next day or two.
Sorry for the delay.

Regards,
Peter Hurley

