Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab3ILUfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:35:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35252 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3ILUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130912134409.GB21212@gondor.apana.org.au>
References: <1375866296-15079-1-git-send-email-fan.du@windriver.com>
	<1375866296-15079-2-git-send-email-fan.du@windriver.com>
	<52021177.6020306@redhat.com>
	<520213F2.5090401@windriver.com>
	<520214C6.6000307@redhat.com>
	<520B4552.2000607@windriver.com>
	<alpine.DEB.2.02.1308181102230.4089@ionos.tec.linutronix.de>
	<5212CCCA.4090907@windriver.com>
	<alpine.DEB.2.02.1309121441420.4089@ionos.tec.linutronix.de>
	<20130912134409.GB21212@gondor.apana.org.au>
Date: Thu, 12 Sep 2013 13:35:02 -0700
X-Google-Sender-Auth: iJ8vabj4WWavN9x3N6okU_rkywc
Message-ID: <CANcMJZCvoynPh4rCkKfnGTHeG2evpKwS0gj_VLmFtmbRusmEog@mail.gmail.com>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set was called
From: John Stultz <john.stultz@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Fan Du <fan.du@windriver.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 6:44 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Sep 12, 2013 at 03:21:24PM +0200, Thomas Gleixner wrote:
>>
>> > (3): http://www.spinics.net/lists/netdev/msg245169.html
>>
>> Thanks for the explanation so far.
>>
>> What's still unclear to me is why these timeouts are bound to wall
>> time in the first place.
>>
>> Is there any real reason why the key life time can't simply be
>> expressed in monotonic time, e.g. N seconds after creation or M
>> seconds after usage? Looking at the relevant RFCs I can't find any
>> requirement for binding the life time to wall time.
>>
>> A life time of 10 minutes does not change when the wall clock is
>> adjusted for whatever reasons. It's still 10 minutes and not some
>> random result of the wall clock adjustments. But I might be wrong as
>> usual :)
>
> Well we started out with straight timers.  It was changed because
> people wanted IPsec SAs to expire after a suspect/resume which
> AFAIK does not touch normal timers.

I'm not sure I've totally groked the specific need here, but if you're
wanting a monotonic clockbase that includes suspend time, then you
might checkout CLOCK_BOOTTIME.

thanks
-john
