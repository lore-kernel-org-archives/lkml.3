Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaHCF3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 01:29:05 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34798 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaHCF3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 01:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <53DDC5EB.3010209@gmail.com>
References: <53DD97B0.8040001@gmail.com> <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com>
 <53DDBE9C.3030609@gmail.com> <53DDC13B.3090206@gmail.com> <53DDC5EB.3010209@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 3 Aug 2014 01:28:32 -0400
Message-ID: <CAJhHMCBEK9bzJaP7tkhTNm8v07dKoxV3FXjNVPFwA2UOHbfn=Q@mail.gmail.com>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: ejt@redhat.com, snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 1:17 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> On 08/03/2014 12:57 AM, Pranith Kumar wrote:
>> On 08/03/2014 12:46 AM, Pranith Kumar wrote:
>>> On 08/02/2014 10:10 PM, Pranith Kumar wrote:
>>>> Corrently adding Anssi this time.
>>>>
>>>> On Sat, Aug 2, 2014 at 10:00 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>>>>> Hello Anssi, Joe, Mike,
>>>>>
>>>>> I just found your patch in the latest rc and wanted to ask a few
>>>>> questions. I am not sure how this patch helps at all other than luck in
>>>>> that dm_cblock_t type is of type int32_t, which should guarantee that it
>>>>> is atomic on most platforms. Which begs the question, what platform did
>>>>> you encounter this problem?
>>>>>
>>>>> The patch purports to solve a race condition by making use of atomic_t.
>>>>> I am not sure that is enough. If indeed there is a race you need to use
>>>>> smp_mb__{before/after}_atomic() for both your uses of atomic_inc() and
>>>>> atomic_set().
>>>>>
>>>>> Also I have a concern about why this mail was not CC'ed on LKML. I had
>>>>> to go to some difficulty in finding this patch. So please CC LKML for
>>>>> such patches.
>>>>>
>>>>> Thanks,
>>>>> --
>>>>> Pranith
>>>>>
>>>>> -- Begin forwarded Message --
>>>>>
>>>>>
>>>>> nr_dirty is updated without locking, causing it to drift so that it is
>>>>> non-zero (either a small positive integer, or a very large one when an
>>>>> underflow occurs) even when there are no actual dirty blocks.
>>>>>
>>>>> Fix that by using an atomic type for nr_dirty.
>>>>>
>>>>> Signed-off-by: Anssi Hannula <anssi hannula iki fi>
>>>>> Cc: Joe Thornber <ejt redhat com>
>>>>> Cc: stable vger kernel org
>>
>

Bah, please ignore all the previous patches about pointers. It is me
who is drunk and got my pointers mixed up. :(

-- 
Pranith
