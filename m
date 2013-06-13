Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3FMDka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:40:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42054 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab3FMDk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:40:29 -0400
X-Spam-Score: -100.8
Message-ID: <51B93EFC.9060008@asianux.com>
Date: Thu, 13 Jun 2013 11:39:40 +0800
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


Sorry for replying late during these days, firstly.


On 06/10/2013 10:12 PM, Thomas Gleixner wrote:
> On Sun, 9 Jun 2013, Chen Gang wrote:
> 
>> > 
>> > According to __internal_add_timer(), in _next_timer_interrupt(), when
>> > 'tv1.vec' find one, but need 'cascade bucket(s)', we still need find
>> > each slot of 'tv*.vec'.
> No, we do not. We only need to scan the first cascade array after the
> enqueued timer. If there is nothing in tv2 which might come before the
> found timer, then any timer in tv3 will be later than the one we found
> in the primary wheel.
> 

OK, thanks, I should read details to confirm it (at least now, I still
not quite be sure about it).


>> > So need reset variable 'found', so can fully scan ''do {...} while()''
>> > for 'tv*.vec'.
> And thereby lose the information, that we already found a timer in the
> scan of the primary array.

Hmm..., I should read details.


And excuse me, I also have to do another things during these days, so
maybe reply late.


Thanks.
-- 
Chen Gang

Asianux Corporation
