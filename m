Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3DLNad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:30:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41174 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3DLNac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:30:32 -0400
Message-ID: <51680C74.9010000@hitachi.com>
Date: Fri, 12 Apr 2013 22:30:28 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 2/2] mm: Add parameters to limit a rate of outputting
 memory error messages
References: <1365665524-nj0fhwkj-mutt-n-horiguchi@ah.jp.nec.com> <20130411140012.GI16732@two.firstfloor.org> <1365691626-w2h428s2-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365691626-w2h428s2-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/11 23:47), Naoya Horiguchi wrote:
> On Thu, Apr 11, 2013 at 04:00:12PM +0200, Andi Kleen wrote:
>>> I don't think it's enough to do ratelimit only for me_pagecache_dirty().
>>> When tons of memory errors flood, all of printk()s in memory error handler
>>> can print out tons of messages.
>>
>> Note that when you really have a flood of uncorrected errors you'll
>> likely die soon anyways as something unrecoverable is very likely to
>> happen. Error memory recovery cannot fix large scale memory corruptions,
>> just the rare events that slip through all the other memory error correction
>> schemes.
>>
>> So I wouldn't worry too much about that.
> 
> I agree.
> My previous comment is valid only when we assume the flooding can happen
> (and I personally don't believe that can happen except for in testing.)
> 
> And for paranoid users, we can suggest that they set up mcelog script
> triggering to turn off vm.memory_failure_recovery when memory errors flood.
> Such users don't expect that memory error handling works fine in flooding,
> so just suppressing kernel messages is pointless.
> 
> Thanks,
> Naoya

Hi Andi, Horiguchi-san, Kosaki-san

Thank you for your comments. I agree with your opinions.
I think that occurrence of uncorrected error is rare event, too.

I introduced a limitation feature using ratelimit in my patch in honor
of the previous discussion a half year ago. In the discussion, Andrew-san
threw a concern of a flood of uncorrected error for the patch proposed by
Horiguchi-san.

I think that ratelimit can be removed to output all "important messages".

I will try to resend patches sepalately, 
one is for outputting error messages related to a corrupted file
and the other is for adding a panic knob to handle data lost of dirty cache
which is caused by both memory error and I/O error.

Regards,
Mitsuhiro Tanino

