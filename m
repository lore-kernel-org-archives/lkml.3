Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936130Ab3DHUhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:37:16 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:42164 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935969Ab3DHUhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomS_=1=QLZrfdD4vhu9Qy0w2JNQxEFrkt_OKjWetrWY4w@mail.gmail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAJ-VmomQaYFMR0G1DM+dno6qB+AdXUom8=kWPzJoOjuzQj81bw@mail.gmail.com>
	<CAFSJ42Zd3s8xKwt4X3LNcupCTntDULxNntMuD-_Xh6_csiGA4A@mail.gmail.com>
	<201304081733.15727.chunkeey@googlemail.com>
	<CAJ-VmomS_=1=QLZrfdD4vhu9Qy0w2JNQxEFrkt_OKjWetrWY4w@mail.gmail.com>
Date: Mon, 8 Apr 2013 22:37:08 +0200
Message-ID: <CAFSJ42b7DD9UVtzT7YWhaEchzwpde0yW=pS3nJVeMCHoVQGBqQ@mail.gmail.com>
Subject: Re: Version number policy!
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@adurom.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian,

Did you have such a situation when e.g. one feature has 2 incompatible
implementations? Let’s say initial implementation of “offloaded TX
rate control” feature was immature and community decides to change
implementation drastically so final realization of this feature is
incompatible with initial. How did carl9170 track such a situation in
feature bitmap?

2013/4/8 Adrian Chadd <adrian@freebsd.org>:
> On 8 April 2013 08:33, Christian Lamparter <chunkeey@googlemail.com> wrote:
>> On Monday, April 08, 2013 11:10:30 AM Eugene Krasnikov wrote:
>>> It’s a good idea to pack bitmap into the tail/header of the firmware
>>> binary to get capabilities even before fw loading. The plan is to add
>>> 8 bytes for caps and also add time stamp. Let me play around with that
>>> and provide fw and driver patch for review.
>>
>> Hm, come to think of it. Kalle, do you think ath9k_htc could use
>> some bits of the fw header format, parser or the complete infrastructure
>> from ath6kl? This could be great for Adrian, because he could
>> just point people to it and they could moved it into the code
>> into /drivers/net/wireless/ath/fw.c.
>
> Just remember that we (ath9k_htc and carl9170) aren't constrained by
> the same kinds of issues that closed firmware is. So version checks
> aren't that bad, because that way over time we don't end up needing to
> maintain lots of special cases for firmware options.
>
> I still like the idea of firmware options for build time options that
> people may wish to use - eg, say we want to support a version of
> ath9k-htc firmware that does offloaded TX rate control, versus not.
> But, maintaining multiple builds of the same firmware is IMHO going to
> be a path towards madness to maintain.
>
> The maintainability is why I'm hoping (!) to keep the number of
> options low and just do "clean slate" moves whenever we shift to the
> next major firmware version.
>
>
> Adrian



-- 
Best regards,
Eugene
