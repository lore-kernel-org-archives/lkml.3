Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFMH1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:27:24 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46069 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaFMH1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:27:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+mtBx9BSe2M7-ALT9AL1J0qPXzJP2LcFG5dCJ3DASnh6-p9gA@mail.gmail.com>
References: <CAMuHMdU6rrpx6xFw71HKexDJUZtfFtL+um6dxZ=EaycgVO312A@mail.gmail.com>
	<CA+mtBx9BSe2M7-ALT9AL1J0qPXzJP2LcFG5dCJ3DASnh6-p9gA@mail.gmail.com>
Date: Fri, 13 Jun 2014 09:27:20 +0200
X-Google-Sender-Auth: rnOT_vxqDw9zIu4XrOGlnL6hpW8
Message-ID: <CAMuHMdUQ-jX+khDtVpOm6XocVG+F3ThH2qM+1BgAtRWzgAsqfQ@mail.gmail.com>
Subject: Re: [-next] Regression: ssh log in slowdown
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tom Herbert <therbert@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

cc lkml, as this is now in mainline

On Fri, Jun 13, 2014 at 2:59 AM, Tom Herbert <therbert@google.com> wrote:
>>     net: Save software checksum complete
>>
>>     In skb_checksum complete, if we need to compute the checksum for the
>>     packet (via skb_checksum) save the result as CHECKSUM_COMPLETE.
>>     Subsequent checksum verification can use this.
>>
>>     Also, added csum_complete_sw flag to distinguish between software and
>>     hardware generated checksum complete, we should always be able to trust
>>     the software computation.
>>
>>     Signed-off-by: Tom Herbert <therbert@google.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> Reverting this commit fixes the issue.
>>
>> Anyone with a clue?
>>
> Hi Geert,
>
> I'm very sorry that I seemed to have missed your initial bug report,
> thanks for bisecting the problem. I have posted a fix for this, please
> verify it if you can

Thanks for your patches!

I assume this is the series "[PATCH 0/4] Checksum fixes"
(marc.info/?l=linux-netdev&m=140261417832399&w=2)?

As I'm not subscribed to netdev, I cannot reply to that thread.

"[PATCH 1/4] net: Fix save software checksum complete" fixes the issue
for me.
However, "[PATCH 2/4] udp: call __skb_checksum_complete when doing full
checksum" reintroduces the exact same bad behavior :-(

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
