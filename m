Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3I3SEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:04:50 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56583 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab3I3SEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130929.175936.607666065014569193.davem@davemloft.net>
References: <1380056988-6717-1-git-send-email-vincent.mc.li@gmail.com>
	<20130929.175936.607666065014569193.davem@davemloft.net>
Date: Mon, 30 Sep 2013 11:04:47 -0700
Message-ID: <CAK3+h2yNG72AKeOrTfvp_x8Zh5JHALFczcNz_VsuU9jjJatPbg@mail.gmail.com>
Subject: Re: [ipv4:PATCH] Allow userspace to specify primary or secondary ip
 on interface
From: Vincent Li <vincent.mc.li@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I found I can use 'ip route replace' command to change the 'src'
address as workaround. Julian also responded in another thread that He
could come up with a patch to sort ip with scope, primary, secondary
preferences.

https://lkml.org/lkml/2013/9/27/482

Vincent

On Sun, Sep 29, 2013 at 2:59 PM, David Miller <davem@davemloft.net> wrote:
> From: Vincent Li <vincent.mc.li@gmail.com>
> Date: Tue, 24 Sep 2013 14:09:48 -0700
>
>> the reason for this patch is that we have a multi blade cluster platform
>> sharing 'floating management ip' and also that each blade has its own
>> management ip on the management interface, so whichever blade in the
>> cluster becomes primary blade, the 'floating mangaement ip' follows it,
>> and we want any of our traffic originated from the primary blade source from
>> the 'floating management ip' for consistency. but in this case, since the local
>> blade management ip is always the primary ip on the mangaement interface and
>> 'floating management ip' is always secondary, kernel always choose the primary
>> ip as source ip address. thus we would like to add the flexibility in kernel to
>> allow us to specify which ip to be primary or secondary.
>
> You have the flexibility already.
>
> You can specify a specific source address ot use in routes.
