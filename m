Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3KPQ71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:59:27 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46880 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3KPQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:59:21 -0500
Message-ID: <5287A463.6020307@koalo.de>
Date: Sat, 16 Nov 2013 17:59:15 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fallback to of_node of parent
References: <528791EF.9060505@koalo.de>	<20131116160601.GA8723@katana> <CABDT8WzUoPmPzDnjD3w+Oj=jUVcMf91+toWDS+hK6CrXLveCFg@mail.gmail.com>
In-Reply-To: <CABDT8WzUoPmPzDnjD3w+Oj=jUVcMf91+toWDS+hK6CrXLveCFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have looked through all bus drivers and in most
cases they have a corresponding line that could be removed.

Although, this patch would break i2c-powermac, because it
relies on the fact that of_node stays NULL.

Any idea how to handle that?

Greetings,
Florian

On 16.11.2013 17:11, Florian Meier wrote:
> Ok, I will try to find all relevant lines.
> Where is the best place to document this?
> 
> Greetings,
> Florian
> 
> 2013/11/16 Wolfram Sang <wsa@the-dreams.de>:
>>
>>> +     if (!dev->of_node && dev->parent)
>>> +             dev->of_node = dev->parent->of_node;
>>> +
>>
>> That is not enough. Current drivers could then have the assignment
>> removed and even more important, this behaviour should be documented.
>>
>> Regards,
>>
>>    Wolfram
>>

