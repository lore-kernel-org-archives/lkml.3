Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3FRKnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:43:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15503 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3FRKnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:43:39 -0400
X-Spam-Score: -100.8
Message-ID: <51C039A8.5000903@asianux.com>
Date: Tue, 18 Jun 2013 18:42:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: timer: looping issue, need reset variable 'found'
References: <51B4A408.4050909@asianux.com> <alpine.LFD.2.02.1306101501160.22970@ionos>
In-Reply-To: <alpine.LFD.2.02.1306101501160.22970@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 10:12 PM, Thomas Gleixner wrote:
> On Sun, 9 Jun 2013, Chen Gang wrote:
> 
>>
>> According to __internal_add_timer(), in _next_timer_interrupt(), when
>> 'tv1.vec' find one, but need 'cascade bucket(s)', we still need find
>> each slot of 'tv*.vec'.
> 
> No, we do not. We only need to scan the first cascade array after the
> enqueued timer. If there is nothing in tv2 which might come before the
> found timer, then any timer in tv3 will be later than the one we found
> in the primary wheel.
> 

If we assume "If there is nothing in tv2 which might come before the
found timer, then any timer in tv3 will ..." is correct.

When we found a timer in 'tv1', we will not search all timers in 'tv2'
(we only search first looping of tv2 for the specific 'slot').

Is it still OK ?


>> So need reset variable 'found', so can fully scan ''do {...} while()''
>> for 'tv*.vec'.
> 
> And thereby lose the information, that we already found a timer in the
> scan of the primary array.
> 

When we found a timer, 'expires' would be set.  So resetting 'found' is
still correct, but may let performance lower (if original implement is
correct too)

I think we can treat original implementation as for speed optimization,
so our discussion is "whether this speed optimization has effect with
correctness".


Thanks.
-- 
Chen Gang

Asianux Corporation
