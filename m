Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbbATDZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:25:05 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:53999 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbATDZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:25:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0K3Oqi8029501, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 1/7] r8152: adjust rx_bottom
Thread-Topic: [PATCH net-next 1/7] r8152: adjust rx_bottom
Thread-Index: AQHQNCzHp+COjrpcAkWYiP9rnzW4lZzIR54A//+CIwCAAIjHUA==
Date: Tue, 20 Jan 2015 03:24:52 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2EE6E9F@RTITMBSV03.realtek.com.tw>
References: <CAE4R7bAv26f-+DW-TmjspJxAb-3Add5sf563mnMUTGCyiqG3rQ@mail.gmail.com>
	<20150119.161333.1471925264489559119.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2EE6E76@RTITMBSV03.realtek.com.tw>
 <20150119.215220.720365670558757349.davem@davemloft.net>
In-Reply-To: <20150119.215220.720365670558757349.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [mailto:davem@davemloft.net] 
> Sent: Tuesday, January 20, 2015 10:52 AM
[...]
> agg->list is not local, you have to use a spinlock to protect
> modifications to it, some other sites which modify agg->list do take
> the lock properly.
> 
> You cannot modify a list like agg->list without proper locking.

Excuse me. I don't understand.

Before step1
   tp_rx_done->listA->listB->listC->listD->...
   rx_queue->
Because the other function would chage tp->rx_done,
I need move the lists with spin lock.

After step1
   tp_rx_done->
   rx_queue->listA->listB->listC->listD->...

Now I dequeue one of the lists from the list_head and
deal with it.
   tp_rx_done->
   rx_queue->listA->listC->listD->...
                    listB

Then, if I want to put it back to rx_queue, I have to
use spin lock. Why? No other function would chage
rx_queue and the items in it.
 
Best Regards,
Hayes
