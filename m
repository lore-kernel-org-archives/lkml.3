Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab3HMGx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:53:56 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:39911 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3HMGxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:53:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1308130828550.1997@localhost6.localdomain6>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
	<20130811155640.GA10070@electric-eye.fr.zoreil.com>
	<alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
	<20130813052036.GA11640@electric-eye.fr.zoreil.com>
	<alpine.DEB.2.02.1308130828550.1997@localhost6.localdomain6>
Date: Tue, 13 Aug 2013 09:53:50 +0300
Message-ID: <CAJJAcocQ59Kc9a1b=jrNSc1akLLN_74yKANMEmLVmvxoRjX4hw@mail.gmail.com>
Subject: Re: question about netif_rx
From: David Shwatrz <dshwatrz@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Francois Romieu <romieu@fr.zoreil.com>, grant.likely@linaro.org,
        rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Sorry. I still don't understand what checksum has to do with it.
Does GRO depends on Rx/Tx checksum ? I don't think so.

In the napi_gro_receive() we check that the device supports
NETIF_F_GRO, but I don't see that we inspect checksum or that
NETIF_F_GRO is depends on checksum.

Can you please explain how checsum offload is related ?

rgs
David

On Tue, Aug 13, 2013 at 9:29 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Tue, 13 Aug 2013, Francois Romieu wrote:
>
>> Julia Lawall <julia.lawall@lip6.fr> :
>> > François Romieu <romieu@fr.zoreil.com> :
>> [...]
>> > > Can you send a netif_receive_skb replacement patch for it ?
>> >
>> > Just to be sure, I just replace netif_rx by netif_receive_skb, nothing
>> > else?
>>
>> Yes. It should imho be fine with a comment incluing your analysis and a
>> few words about the current state of checksum offloading support.
>
> I wouldn't know what to say about the checksum part.  It is not supported
> so I should use netif_receive_skb?
>
> thanks,
> julia
