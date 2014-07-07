Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaGGIDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:03:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64112 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGGIDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <1404682932.4501.6.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140705202821.GA25880@mwanda>
	<1404647816-7564-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<1404682932.4501.6.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Mon, 7 Jul 2014 11:03:41 +0300
Message-ID: <CANZNk81v7YHKpzjZ65KHdUi1BgBiV_ibZO24b8uauuCVZeUv2A@mail.gmail.com>
Subject: Re: [PATCH] appletalk: Set skb with destructor
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        acme@ghostprotocols.net, netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-07 0:42 GMT+03:00 Eric Dumazet <eric.dumazet@gmail.com>:
>>       /* Queue packet (standard) */
>> +     sock_hold(sock);
>> +     skb->destructor = atalk_skb_destructor;
>>       skb->sk = sock;
>
> This part is not needed : sock_queue_rcv_skb() already does the right
> thing : It calls skb_set_owner_r(skb, sk);
>
> You should therefore remove the "skb->sk = sock;" line

If it is so, i think this should be as another patch with its own reasoning.

-- 
Andrey Utkin
