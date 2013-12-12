Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LLR60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:58:26 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:34111 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3LLR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:58:22 -0500
Message-ID: <52A9F93A.5040104@gmail.com>
Date: Thu, 12 Dec 2013 12:58:18 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, dvlasenk@redhat.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        jpirko@redhat.com
Subject: Re: [patch net-next v2] ipv6: log autoconfiguration failures
References: <1386762314-5149-1-git-send-email-dvlasenk@redhat.com>	<20131211192138.GB4675@order.stressinduktion.org>	<52A99B56.1070503@redhat.com> <20131212.122241.2022824170198915190.davem@davemloft.net>
In-Reply-To: <20131212.122241.2022824170198915190.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:22 PM, David Miller wrote:
> From: Denys Vlasenko <dvlasenk@redhat.com>
> Date: Thu, 12 Dec 2013 12:17:42 +0100
> 
>> I can easily imagine their frustration. Kernel _knows_ why
>> it didn't work, and it's not expected to normally pappen,
>> why didn't it tell anything about it?
> 
> Packets are dropped silently, ARP fails and entries go stale silently,
> none of this is logged with kernel messages, why is ipv6 autoconf so
> unique and important to justify different behavior?

But most of the changes from V2 report an actual error condition in
the kernel: addr_len is not set correctly for the device type.
These changes are worth keeping and not just as pr_debug.  Having
a counter of these failures will not provide much useful data if you
happen to have multiple such device and where one happens to work and
the other doesn't (very unlikely, I know).

> 
> Give it statistics just like we have for every other kind of similar
> event.

The fact that link-local address could not be generated for a specific
device type does not lend itself well to counting.  There is no way
from to tell from the counter which device does not support IPv6 autoconfig.

-vlad
