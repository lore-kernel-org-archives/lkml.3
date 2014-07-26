Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaGZPky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:40:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50854 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaGZPkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <53D2C38A.70601@oracle.com>
References: <53C2FF3D.4030201@oracle.com>
	<53D2768E.2040902@samsung.com>
	<53D2C38A.70601@oracle.com>
Date: Sat, 26 Jul 2014 19:40:51 +0400
Message-ID: <CAPAsAGwxk7qO7j8-fRWNGuoFKaNoadwtHxrps41hK9jH5=KTQA@mail.gmail.com>
Subject: Re: net: socket: NULL ptr deref in sendmsg
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-26 0:52 GMT+04:00 Sasha Levin <sasha.levin@oracle.com>:
> On 07/25/2014 11:23 AM, Andrey Ryabinin wrote:
>> After this report there was no usual "Unable to handle kernel NULL pointer dereference"
>> and this gave me a clue that address 0 is mapped and contains valid socket address structure in it.
>
> Interesting. Does it mean that all network protocols that check it for being NULL instead of checking
> the length are incorrect?
>

I think they are correct. After verify_iovec() we should have either
both msg->msg_name == 0 and msg->msg_namelen == 0,
or  both != 0 (and msg_name should be a kernel address).

That bug allows to leave verify_iovec() with msg_namelen > 0 and
msg_name == NULL, causing troubles for protocols checking only
msg_namelen.

> (such as:)
>
>         if (msg->msg_name) {
>                 DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
>
>                 [...]
>
>
> Thanks,
> Sasha
>

-- 
Best regards,
Andrey Ryabinin
