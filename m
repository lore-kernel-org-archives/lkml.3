Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3HKE57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 00:57:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38136 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3HKE56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 00:57:58 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1376195819.7006.18.camel@marge.simpson.net>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org> <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net> <5206659F.9070705@zytor.com> <1376194657.7006.11.camel@marge.simpson.net> <520712AE.6060904@zytor.com> <1376195819.7006.18.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 10 Aug 2013 21:57:26 -0700
To: Mike Galbraith <bitbucket@online.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Message-ID: <f6227e5d-597b-4818-876a-3a21893cdd93@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That sounds like an issue with specific preemption policies.

Mike Galbraith <bitbucket@online.de> wrote:
>On Sat, 2013-08-10 at 21:27 -0700, H. Peter Anvin wrote: 
>> On 08/10/2013 09:17 PM, Mike Galbraith wrote:
>> >>
>> >> Do you have any quantification of "munches throughput?"  It seems
>odd
>> >> that it would be worse than polling for preempt all over the
>kernel, but
>> >> perhaps the additional locking is what costs.
>> > 
>> > I hadn't compared in ages, so made some fresh samples.
>> > 
>> > Q6600 3.11-rc4
>> > 
>> > vmark
>> > voluntary     169808     155826     154741     1.000
>> > preempt       149354     124016     128436      .836
>> > 
>> > That should be ~worst case, it hates preemption. 
>> > 
>> > tbench 8
>> > voluntary    1027.96    1028.76    1044.60     1.000
>> > preempt       929.06     935.01     928.64      .900
>> > 
>> > hackbench -l 10000
>> > voluntary     23.146     23.124     23.230     1.000
>> > preempt       25.065     24.633     24.789     1.071
>> > 
>> > kbuild vmlinux
>> > voluntary  3m44.842s  3m42.975s  3m42.954s     1.000
>> > preempt    3m46.141s  3m45.835s  3m45.953s     1.010
>> > 
>> > Compute load comparisons are boring 'course.
>> > 
>> 
>> I presume voluntary is indistinguishable from no preemption at all?
>
>No, all preemption options produce performance deltas.
>
>> Either way, that is definitely a reproducible test case, so if
>someone
>> is willing to take on optimizing preemption they can use vmark as the
>> litmus test.  It would be really awesome if we genuinely could get
>the
>> cost of preemption down to where it just doesn't matter.
>
>You have to eat more scheduler cycles, that's what PREEMPT does for a
>living.  Release a lock, wham.
>
>-Mike

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
