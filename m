Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBCHCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:02:23 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:54292 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaBCHCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:02:21 -0500
Message-ID: <52EF3EF2.30900@linux.vnet.ibm.com>
Date: Mon, 03 Feb 2014 12:32:10 +0530
From: Sohny Thomas <sthomas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: nicolas.dichtel@6wind.com, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
        davem@davemloft.net, kumuda <kumuda@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipv6: default route for link local address is not added
 while assigning a address
References: <52E8A2AA.3090507@linux.vnet.ibm.com> <52E8DA37.7010208@6wind.com>
In-Reply-To: <52E8DA37.7010208@6wind.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020307-1396-0000-0000-0000043BB137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 January 2014 04:08 PM, Nicolas Dichtel wrote:
> Le 29/01/2014 07:41, Sohny Thomas a écrit :
>> Resending this on netdev mailing list:
>> Default route for link local address is configured automatically if
>> NETWORKING_IPV6=yes is in ifcfg-eth*.
>> When the route table for the interface is flushed and a new address is
>> added to
>> the same device with out removing linklocal addr, default route for
>> link local
>> address has to added by default.
>>
>> I have found the issue to be caused by this checkin
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/ipv6?id=62b54dd91567686a1cb118f76a72d5f4764a86dd
>>
>>
>>
>> According to this change :
>> He removes adding a link local route if any other address is added ,
>> applicable
>> across all interfaces though there's mentioned only lo interface
>> So below patch fixes for other devices
>>
>> Signed-off-by: Sohny THomas <sohthoma@linux.vnet.ibm.com>
> Your email client has corrupted the patch, it cannot be applied.
> Please read Documentation/email-clients.txt
Sorry about that. Will resend again
>
> About the patch, I still think that the flush is too agressive. Link local
> routes are marked as 'proto kernel', removing them without the link local
> address is wrong.
>
> With this patch, you will add a link local route even if you don't have
> a link local address.
I think it wouldn't hurt to have a Link local route for NDP  in case a 
the routes become unreachable

-Regards,
Sohny
>
>
>

