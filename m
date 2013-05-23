Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3EWGgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:36:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53863 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab3EWGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:36:44 -0400
X-Sasl-enc: CQnmanVls2XiRdbFlFM+86LTqaISmhWgyFZfCK1onxTQ 1369290983
Message-ID: <519DB8E6.4020709@signal11.us>
Date: Thu, 23 May 2013 02:36:22 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Hauweele <david@hauweele.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net
Subject: Re: [PATCH beta 1] 0/3] Fix race conditions in mrf24j40 interrupts
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com> <1369188080-8904-1-git-send-email-alan@signal11.us> <519C278F.5030809@signal11.us> <CAO+c-UV1bZZEE=9=7VVn3f1eLWzCpYCK9eZnnvzNwcPOKKtKLA@mail.gmail.com>
In-Reply-To: <CAO+c-UV1bZZEE=9=7VVn3f1eLWzCpYCK9eZnnvzNwcPOKKtKLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/13 4:32 PM, David Hauweele wrote:
> I cannot use level-triggered interrupts with GPIO on the RPi, so I
> cannot test this specific patch.

Is there another interrupt line you can tie into which does support 
level-trigger interrupts (INT0 or something)?

> However I agree with the idea of level-triggered interrupts, that
> would fix all major problems related to missed interrupts.
>
> Beside this I'm running a ping -f since more than two hours now and it
> seems to work well.
>

So that surprises me. I thought level-trigger interrupts were the thing 
that would fix this problem, and if you're not running with that patch, 
you just have the INIT_COMPLETION() fix (which you said didn't fix your 
issue) and the threaded interrupts patch, which I was fairly sure I had 
determined wasn't fixing any actual race-condition-related problems.

I'm glad, but surprised that you're no longer seeing issues.

Alan.

>
> 2013/5/22 Alan Ott <alan@signal11.us>:
>> On 05/21/2013 10:01 PM, Alan Ott wrote:
>>> David Hauweele noticed that the mrf24j40 would hang arbitrarily after some
>>> period of heavy traffic.  Two race conditions were discovered, and the
>>> driver was changed to use threaded interrupts, since the enable/disable of
>>> interrupts in the driver has recently been a lighning rod whenever issues
>>> arise related to interrupts (costing engineering time), and since threaded
>>> interrupts are the right way to do it.
>>>
>>> Alan Ott (3):
>>>    mrf24j40: Move INIT_COMPLETION() to before packet transmission
>>>    mrf24j40: Use threaded IRQ handler
>>>    mrf24j40: Use level-triggered interrupts
>>>
>>>   drivers/net/ieee802154/mrf24j40.c | 31 +++++++++----------------------
>>>   1 file changed, 9 insertions(+), 22 deletions(-)
>>
>> I forgot to add, I ran ping -f both ways all afternoon (6.5 hours), and
>> it seems solid.
>>

