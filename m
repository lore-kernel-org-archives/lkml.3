Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3BDOwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:52:50 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37870 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:52:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130201141211.1adadfe5.akpm@linux-foundation.org>
References: <1358928657-15781-1-git-send-email-christian.gmeiner@gmail.com>
 <7AFBFD79B857054D97821A9BD3FBFA9744D05BD2@ATFKEX06.bachmann.at>
 <CAH9NwWdciqHSkkMSk4CW4XX+d6JSZBnvw52Svu8M4o-PGMQsDA@mail.gmail.com> <20130201141211.1adadfe5.akpm@linux-foundation.org>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 4 Feb 2013 15:46:34 +0100
Message-ID: <CAH9NwWfRL3HpfhLW5FqmWJC+NYHagoQXMoavAzMYciHRDg6mdQ@mail.gmail.com>
Subject: Re: [PATCH] leds-ot200: Fix error caused by shifted mask
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "GMEINER.Christian" <C.GMEINER@bachmann.info>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bryan Wu <cooloney@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/1 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 1 Feb 2013 16:08:15 +0100
> Christian Gmeiner <christian.gmeiner@gmail.com> wrote:
>
>> ping
>
> Bryan is handling LEDs patches (see ./MAINTAINERS).  Without a cc he
> presumably missed this in the lkml flood.

You are right...

~/kernel/linux-3.7.6$ ./scripts/get_maintainer.pl -f drivers/leds/leds-ot200.c
Bryan Wu <cooloney@gmail.com> (maintainer:LED SUBSYSTEM)
Richard Purdie <rpurdie@rpsys.net> (maintainer:LED SUBSYSTEM)
linux-leds@vger.kernel.org (open list:LED SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

Next time I will add Bryan to CC

>
>> 2013/1/23 GMEINER.Christian <C.GMEINER@bachmann.info>:
>> >> -----Urspr__ngliche Nachricht-----
>> >> Von: Christian Gmeiner [mailto:christian.gmeiner@gmail.com]
>> >> Gesendet: Mittwoch, 23. Januar 2013 09:11
>> >> An: linux-next@vger.kernel.org; akpm@linux-foundation.org;
>> >> rpurdie@rpsys.net; linux-kernel@vger.kernel.org; GMEINER.Christian
>> >> Cc: Christian Gmeiner
>> >> Betreff: [PATCH] leds-ot200: Fix error caused by shifted mask
>> >>
>> >> During the development of this driver an in-house register documentation
>> >> was used. The last weeks some integration tests were done and this problem
>> >> was found. It turned out that the released register documentation is wrong.
>> >>
>> >> The fix is very simple: shift all masks by one.
>> >>
>
> The changelog failed to describe the effects of the bug it fixes.  This
> is a grave (and all too common) omission; it makes it difficult for
> others to determine whether the patch should be backported into earlier
> kernels.
>
> So, please tell us.  And feel free to explain whether you believe the
> fix should be backported.

Our customers can control LEDs from userspace via Java, C++ or what every. They
have running/working applications where they want to control led_3 but
led_2 get's
used. I got a bug report in our in-house bug tracker so it would be
great if this patch can make it into 3.7.x series.

thanks
--
Christian Gmeiner, MSc
