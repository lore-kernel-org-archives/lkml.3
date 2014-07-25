Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbaGYWP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:15:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55220 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761119AbaGYWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:15:56 -0400
X-Sasl-enc: 7jcu8M91j9kkJm/uJtVoCEaGe1cFKQhKK3TrPXnO4emv 1406326555
Message-ID: <1406326553.13203.11.camel@localhost>
Subject: Re: net: socket: NULL ptr deref in sendmsg
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Date: Sat, 26 Jul 2014 00:15:53 +0200
In-Reply-To: <53D2C38A.70601@oracle.com>
References: <53C2FF3D.4030201@oracle.com> <53D2768E.2040902@samsung.com>
	 <53D2C38A.70601@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 2014-07-25 at 16:52 -0400, Sasha Levin wrote:
> On 07/25/2014 11:23 AM, Andrey Ryabinin wrote:
> > After this report there was no usual "Unable to handle kernel NULL pointer dereference"
> > and this gave me a clue that address 0 is mapped and contains valid socket address structure in it.
> 
> Interesting. Does it mean that all network protocols that check it for being NULL instead of checking
> the length are incorrect?

I would not like to go down this route and keep msg->msg_namelen and
msg->msg_name in sync after verify_iovec.

> (such as:)
> 
>         if (msg->msg_name) {
>                 DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
> 
>                 [...]
> 

Thanks,
Hannes

