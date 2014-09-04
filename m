Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaIDKRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:17:20 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:42986 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaIDKRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:17:17 -0400
Message-ID: <54083C0F.1040807@ahsoftware.de>
Date: Thu, 04 Sep 2014 12:16:47 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org> <20140812202129.GA20344@home.goodmis.org> <yw1xr40l2whi.fsf@unicorn.mansr.com> <20140813082756.GB2923@twins.programming.kicks-ass.net> <20140813090013.GA20581@pd.tnic> <53F242D1.4050506@ahsoftware.de> <20140904075453.GK3190@worktop.ger.corp.intel.com>
In-Reply-To: <20140904075453.GK3190@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.09.2014 09:54, schrieb Peter Zijlstra:
> On Mon, Aug 18, 2014 at 08:15:45PM +0200, Alexander Holler wrote:
>>
>> Hmm, a sane and maintainable solution would use C++ with which people don't
>> have to manually build lists or hashes for every structure like in the
>> kernel (generic programming done right). So you won't find much kernel
>> developers there. ;)
>>
>
> Troll a lot do you? ;-)

Not really.

I just hate all the stuff which is necessary in C when I e.g. want a 
sorted list, map or set for whatever structure I have the need for. I 
had fun doing so 30 years ago, when I started to learn C, but now it's 
just tiring.

E.g. for the dependency based initialization order with DT I would have 
liked it to have a list (or map or set) of strings (sorted) in order to 
find a driver by name (fast). In C++ it would need something < 10 lines 
of source and I would be able to change the sorting algorithm from list 
to map(hash) or similiar by changing a few lines. Doing so in C is just 
a pain. Not to speak about all the possible errors when implementing the 
stuff in C again and again. Ok, the kernel provides some macros for 
lists, but e.g. they can be found only in the kernel (which means many 
people don't know or remember how to use them) and are by far not that 
flexible.

> While I like C++ (and quite a number of kernel people can in fact write
> C++ no problem) we can have a long debate about whether the STL is in
> fact 'done right' :-)

Up to now I haven't seen something really better. Of course, there are a 
lot of other programming languages which do make it easy to use lists, 
maps and similiar, but none of them is as fast and portable as C++ while 
still allowing to do low-level things (if necessary).

> Also, I don't think init (as in PID-1) should be a large program, and
> therefore writing it in C would be entirely reasonable.

It's a myth that C++ ends up in bigger code than C. At least in my 
experience. Especially when the latest additions to C++ are in effect 
(like the move-semantics in C++11 I like quiet a lot and which you get 
almost for free (by changing nothing) when you use the STL). Thread 
support is now also standardized (in C++11), quiet nice to use.

Regards,

Alexander Holler
