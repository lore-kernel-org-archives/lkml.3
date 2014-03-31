Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaCaM6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:58:51 -0400
Received: from 0.mx.nanl.de ([217.115.11.12]:42185 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaCaM6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:58:49 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2014 08:58:49 EDT
MIME-Version: 1.0
In-Reply-To: <20140331085642.GL6991@mwanda>
References: <5335F74A.9020507@gmail.com> <20140331085642.GL6991@mwanda>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 31 Mar 2014 14:47:58 +0200
Message-ID: <CAOiHx=kvEX5ay+eXf-+6tdN=oNNKTGfCq6DA=JHTS-WnA3tKGQ@mail.gmail.com>
Subject: Re: Staging:et131x: change memcpy() ether_addr_copy()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: paulmcquad <paulmcquad@gmail.com>, "Zhao, Gang" <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:56 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Fri, Mar 28, 2014 at 10:27:22PM +0000, paulmcquad wrote:
>> >From 63f3c8948d5264ab22695502b201ff50edb9028d Mon Sep 17 00:00:00 2001
>> From: Paul McQuade <paulmcquad@gmail.com>
>> Date: Fri, 28 Mar 2014 22:16:22 +0000
>> Subject: [PATCH] Staging:et131x: change memcpy()  ether_addr_copy()
>
> Don't include this header block.
>
>>
>> replace memcpy() with ether_addr_copy()
>> make checkpatch.pl clean
>
> Patch doesn't apply to linux-next.
>
>> @@ -4337,7 +4337,7 @@ static void et131x_multicast(struct net_device *netdev)
>>      netdev_for_each_mc_addr(ha, netdev) {
>>          if (i == NIC_MAX_MCAST_LIST)
>>              break;
>> -        memcpy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
>> +    ether_addr_copy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
>
> There is an indenting error here.

Also ether_addr_copy does not have a third argument, so it would not
even compile.


Regards
Jonas
