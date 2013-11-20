Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3KTD3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 22:29:05 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38435 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3KTD3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 22:29:03 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rAK3Sgkw016322, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, "'nic_swsd'" <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com><1384831511-1625-1-git-send-email-hayeswang@realtek.com><1384831511-1625-4-git-send-email-hayeswang@realtek.com> <20131119.152536.146706009595105149.davem@davemloft.net>
Subject: RE: [PATCH net v4 3/4] r8152: support stopping/waking tx queue
Date: Wed, 20 Nov 2013 11:28:46 +0800
Message-ID: <9C2E97E7BED9426ABE0FF4F63E12E33D@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac7lZYSCUTCXJxUhRMux5ihooSDGuAANTKUg
In-Reply-To: <20131119.152536.146706009595105149.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [mailto:davem@davemloft.net] 
[...]
> This is racy.
> 
> You have nothing which synchronizes r8152_tx_agg_fill() and 
> rtl8152_start_xmit(),
> therefore:
> 
> > +	if (netif_queue_stopped(tp->netdev))
> > +		netif_wake_queue(tp->netdev);
> > +
> 
> A netif_stop_queue() can occur right after the 
> netif_queue_stopped() check,
> meaning you can end up with the queue being stopped forever 
> and the TX queue
> stuck.

If the situation occurs, it means there is no tx buffer at that time. If the
netif_wake_queue() is called, only one more packet would be queued and the tx
queue would be stopped again after calling rtl8152_start_xmit(). That is, it
is not necessary to wake the queue. Besides, after the tx is completed, another
tasklet would be scheduled if there is any packet which is queued in the list.
That is, the r8152_tx_agg_fill() would be called and the netif_queue_stopped()
would be check againg, so the tx queue would not be stopped forever.
 
Best Regards,
Hayes

