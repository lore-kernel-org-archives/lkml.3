Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3E0WMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 18:12:55 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:54470 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab3E0WMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 18:12:54 -0400
Message-ID: <51A3DA5E.6080501@gmail.com>
Date: Tue, 28 May 2013 00:12:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        andrew@lunn.ch, jason@lakedaemon.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, buytenh@wantstofly.org,
        grant.likely@linaro.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround
 on DT ethernet
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com> <51A33447.80305@gmail.com> <1369655404.3557.33.camel@pasglop> <2255648.0KEmXfjCx5@wuerfel> <1369691406.3557.35.camel@pasglop>
In-Reply-To: <1369691406.3557.35.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 11:50 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-27 at 14:47 +0200, Arnd Bergmann wrote:
>> On Monday 27 May 2013 21:50:04 Benjamin Herrenschmidt wrote:
>>> However, that wouldn't help much with the allocation/leak problem,
>>> though at least it would be easier to use. It could also *try* to re-use
>>> the current allocation if the new content is of smaller or equal size.
>>
>> I thought that dtc tried to aggressively save space by folding identical
>> strings. If you tried to reuse a property that had its contents shared
>> with another one, you would get interesting results I guess.
>
> It used to be only property names, unless that has changed in recent
> dtc. But that's a good point, we probably want a flag in struct property
> like we have for nodes, indicating whether it comes from the original
> fdt data pool or not.

But isn't that what current sparc implementation of of_set_property does
when it marks the property as dynamic?

Anyway, this definitely exceeds my knowledge of OF API for sure, so what
do I do about the MAC workaround now?

Prepare the patch with global arrays and switch to some of_set_property
as soon as it is available?

Sebastian

