Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaHUPK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:10:28 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48632 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHUPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:10:27 -0400
Message-ID: <53F60BE0.5050509@gmail.com>
Date: Thu, 21 Aug 2014 09:10:24 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf on biarch
References: <20140808184049.65e7d32b@parrot.com>	<53E52A1C.8010504@gmail.com> <20140818111656.40ff6ae7@parrot.com>
In-Reply-To: <20140818111656.40ff6ae7@parrot.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/14, 3:16 AM, Matthieu CASTET wrote:
> Le Fri, 8 Aug 2014 13:50:52 -0600,
> David Ahern <dsahern@gmail.com> a écrit :
>
>> On 8/8/14, 10:40 AM, Matthieu CASTET wrote:
>>> Hi,
>>>
>>> I have a 64 bits kernel running with 32 bits binaries.
>>> If I run 32 bits perf on this 64 bits kernel 3.14, I got weird result :
>>>
>>> - perf trace doesn't work [1]
>>
>> I have patches that fix that:
>>       git clone https://github.com/dsahern/linux.git
>>       git checkout perf-full-monty
>>
>> And if autodetection fails you can manually force it with -M x86.
>>
> Thanks david.
> It is better, but it seems there are problem with argument parsing.
>
> For example for
> "mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) = 0xf77e2000"
> I got :
> - 2.847 ( 0.004 ms): mmap2(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4:
> 3, arg5: 0         ) = -143273984
>
>
> Note the 4096 position. Running perf trace on a 32 bits kernel give
> 4096 at arg1.

What kernel version? And are you running my perf command or did you 
extract the relevant patches?

Using a mixed system here:

# uname -a
Linux switch 3.4.10 #1 SMP Wed Jul 30 13:10:46 PDT 2014 x86_64 GNU/Linux

# file /bin/ls
/bin/ls: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), 
dynamically linked (uses shared libs), for GNU/Linux 2.6.34, stripped

And comparing 'strace ls':

mmap2(0x41217000, 33356, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 
3, 0) = 0x41217000

to 'perf trace ls':

1.239 ( 0.015 ms): mmap2(arg0: 1092710400, arg1: 33356, arg2: 5, arg3: 
2050, arg4: 3, arg5: 0) = 1092710400

I am seeing a consistent output between strace and perf-trace for 32-bit 
app on 64-bit kernel -- though perf-trace does need the pretty print for 
mmap2.

David
