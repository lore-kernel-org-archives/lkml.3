Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaDUIOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:14:14 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:56078 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDUIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:14:09 -0400
Message-ID: <5354D34B.4030607@mentor.com>
Date: Mon, 21 Apr 2014 16:14:03 +0800
From: Chung-Lin Tang <chunglin_tang@mentor.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ley Foon Tan <lftan@altera.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Chung-Lin Tang <cltang@CODESOURCERY.COM>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<53518FAC.8020504@zytor.com>	<201404191730.54400.arnd@arndb.de> <CAFiDJ5-PiUWetRMp65VTo4pvZM65r3WBjCZVWmxW0XnqAyO-GA@mail.gmail.com> <5354AD36.5090809@zytor.com>
In-Reply-To: <5354AD36.5090809@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2014 08:14:07.0180 (UTC) FILETIME=[AA7BE8C0:01CF5D39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/4/21 1:31 PM, H. Peter Anvin wrote:
> On 04/20/2014 10:23 PM, Ley Foon Tan wrote:
>> On Sat, Apr 19, 2014 at 11:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Friday 18 April 2014, H. Peter Anvin wrote:
>>>> Did the generic headers ever get updated to match Linus' guidance that
>>>> any new architecture ports should use a 64-bit time_t?
>>>
>>> No, unfortunately not. With my rule that every architecture that gets
>>> added needs to clean up asm-generic some more, to make it easier to add
>>> the next one, we should probably do for nios2.
>>>
>>>         Arnd
>>
>> Can you give me the documentation on this new guidance and point me
>> any architecture have implemented this?
>> Thanks.
>>
> 
> We implemented it in the x32 ABI for x86.  In generic code this is keyed
> by COMPAT_USE_64BIT_TIME, but in your case it isn't actually a matter of
> compat, so it should be easier.
> 
> See this thread including the discussion about time_t:
> 
> https://lkml.org/lkml/2011/8/26/415
> 
> 	-hpa


I'm not sure why we need CONFIG_USE_64BIT_TIME? We don't have any
32-on-64 problems.

My understanding of what Arnd meant, was to clean up
asm-generic/posix_types.h such that for example, time_t should be
defined as a 'long long' type, which should be 64-bit almost everywhere.
At least AFAIK, that should work for all current asm-generic users.

Thanks,
Chung-Lin

