Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3EVUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:32:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60398 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3EVUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <519C278F.5030809@signal11.us>
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
	<1369188080-8904-1-git-send-email-alan@signal11.us>
	<519C278F.5030809@signal11.us>
Date: Wed, 22 May 2013 22:32:15 +0200
X-Google-Sender-Auth: Fgd79xV2KlhJsJ9JjPlzLUWx1FY
Message-ID: <CAO+c-UV1bZZEE=9=7VVn3f1eLWzCpYCK9eZnnvzNwcPOKKtKLA@mail.gmail.com>
Subject: Re: [PATCH beta 1] 0/3] Fix race conditions in mrf24j40 interrupts
From: David Hauweele <david@hauweele.net>
To: Alan Ott <alan@signal11.us>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I cannot use level-triggered interrupts with GPIO on the RPi, so I
cannot test this specific patch.
However I agree with the idea of level-triggered interrupts, that
would fix all major problems related to missed interrupts.

Beside this I'm running a ping -f since more than two hours now and it
seems to work well.

David

2013/5/22 Alan Ott <alan@signal11.us>:
> On 05/21/2013 10:01 PM, Alan Ott wrote:
>> David Hauweele noticed that the mrf24j40 would hang arbitrarily after some
>> period of heavy traffic.  Two race conditions were discovered, and the
>> driver was changed to use threaded interrupts, since the enable/disable of
>> interrupts in the driver has recently been a lighning rod whenever issues
>> arise related to interrupts (costing engineering time), and since threaded
>> interrupts are the right way to do it.
>>
>> Alan Ott (3):
>>   mrf24j40: Move INIT_COMPLETION() to before packet transmission
>>   mrf24j40: Use threaded IRQ handler
>>   mrf24j40: Use level-triggered interrupts
>>
>>  drivers/net/ieee802154/mrf24j40.c | 31 +++++++++----------------------
>>  1 file changed, 9 insertions(+), 22 deletions(-)
>
> I forgot to add, I ran ping -f both ways all afternoon (6.5 hours), and
> it seems solid.
>
