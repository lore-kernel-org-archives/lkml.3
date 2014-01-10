Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbaAJQdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:33:14 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34226 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbaAJQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:33:12 -0500
Message-ID: <52D020C4.30105@6wind.com>
Date: Fri, 10 Jan 2014 17:33:08 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: sohny thomas <sohny.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org, davem@davemloft.net,
        kumuda <kumuda@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: ipv6: default route for link local address is not added while
 assigning a address
References: <52CFE594.8010808@gmail.com>
In-Reply-To: <52CFE594.8010808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: netdev

Le 10/01/2014 13:20, sohny thomas a écrit :
> Default route for link local address is configured automatically if
> NETWORKING_IPV6=yes is in ifcfg-eth*.
> When the route table for the interface is flushed and a new address is added to
> the same device with out removing linklocal addr, default route for link local
> address has to added by default.
I would say that removing the link local route but not the link local address
is a configuration problem.
If you remove a connected route but not the associated address, you will have
the same problem.

>
> I have found the issue to be caused by this checkin
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/ipv6?id=62b54dd91567686a1cb118f76a72d5f4764a86dd
>
>
> According to this change :
> He removes adding a link local route if any other address is added , applicable
> across all interfaces though there's mentioned only lo interface
> So below patch fixes for other devices
