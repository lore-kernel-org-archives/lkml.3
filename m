Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaAMItg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:49:36 -0500
Received: from mail-pb0-f65.google.com ([209.85.160.65]:54637 "EHLO
	mail-pb0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaAMItd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:49:33 -0500
Message-ID: <52D3A885.2080107@gmail.com>
Date: Mon, 13 Jan 2014 14:19:09 +0530
From: sohny thomas <sohny.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, davem@davemloft.net,
        kumuda <kumuda@linux.vnet.ibm.com>, hannes@stressinduktion.org
Subject: Re: ipv6: default route for link local address is not added while
 assigning a address
References: <52D2F201.1090903@gmail.com>
In-Reply-To: <52D2F201.1090903@gmail.com>
X-Forwarded-Message-Id: <52D2F201.1090903@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 January 2014 10:46 PM, Hannes Frederic Sowa wrote:
> On Fri, Jan 10, 2014 at 05:33:08PM +0100, Nicolas Dichtel wrote:
>> CC: netdev
>>
>> Le 10/01/2014 13:20, sohny thomas a écrit :
>>> Default route for link local address is configured automatically if
>>> NETWORKING_IPV6=yes is in ifcfg-eth*.
>>> When the route table for the interface is flushed and a new address is
>>> added to
>>> the same device with out removing linklocal addr, default route for link
>>> local
>>> address has to added by default.
>> I would say that removing the link local route but not the link local
>> address
>> is a configuration problem.
>> If you remove a connected route but not the associated address, you will
>> have
>> the same problem.
> We have some user accessible routes that are essential for IPv6 stack
> to work at all. So I don't know if I can agree with that.
>
> Maybe flush is a bit too aggressive?
>
Hi ,

Thank you for the inputs.

In the test for ipv6 default address selection , we are testing the rule
2 as specified in RFC 6724

   If Scope(SA) < Scope(SB): If Scope(SA) < Scope(D), then prefer SB
     and otherwise prefer SA.
     Similarly, if Scope(SB) < Scope(SA): If Scope(SB) < Scope(D), then
     prefer SA and otherwise prefer SB.

Test:

   Check 04:
      Destination: ff08::2(OS)
      Candidate Source Addresses: fec0::1(SS) or LLA(LS)
      Result: fec0::1(SS)

      Scope(LLA) < Scope(fec0::1): If Scope(LLA) < Scope(ff08::2),  yes, 
prefer fec0::1


Now in the test its flushing all the routes and adding an address ,
which in causes to add route into the routing table including the link
local routes.
Earlier in 2.6.32 it used to work fine now due to the above mentioned
check-in this is not happening

Of course we can still just delete a route and add , but even if we
delete the link local route, IMHO i think it should update the LLA route
when the interface is next added an address or bought up which ever is
the case.

Regards,
Sohny


