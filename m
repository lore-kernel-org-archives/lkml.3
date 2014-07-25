Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbaGYU6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:58:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31371 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaGYU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:57:58 -0400
Message-ID: <53D2C38A.70601@oracle.com>
Date: Fri, 25 Jul 2014 16:52:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: net: socket: NULL ptr deref in sendmsg
References: <53C2FF3D.4030201@oracle.com> <53D2768E.2040902@samsung.com>
In-Reply-To: <53D2768E.2040902@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 11:23 AM, Andrey Ryabinin wrote:
> After this report there was no usual "Unable to handle kernel NULL pointer dereference"
> and this gave me a clue that address 0 is mapped and contains valid socket address structure in it.

Interesting. Does it mean that all network protocols that check it for being NULL instead of checking
the length are incorrect?

(such as:)

        if (msg->msg_name) {
                DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);

                [...]


Thanks,
Sasha
