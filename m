Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaBSDCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:02:25 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41627 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBSDCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:02:23 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1J31k1r027380, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com> <1392731351-25502-13-git-send-email-hayeswang@realtek.com> <20140218232850.GB13394@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 12/14] r8152: replace netif_rx withnetif_receive_skb
Date: Wed, 19 Feb 2014 11:01:51 +0800
Message-ID: <79F93FE4FECD48E7B7B6C6EE93151CB6@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20140218232850.GB13394@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Thread-Index: Ac8tATEo3BPEgPo/TxOO/cvgsIfXtwAFruUg
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, February 19, 2014 7:29 AM
> To: Hayes Wang
> Cc: netdev@vger.kernel.org; nic_swsd@realtek.com; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net-next 12/14] r8152: replace netif_rx 
> withnetif_receive_skb
> 
> Hayes Wang <hayeswang@realtek.com> :
> > Replace netif_rx with netif_receive_skb to avoid disabling irq frequently
> > for increasing the efficiency.
> 
> read_bulk_callback is issued in irq context. It could thus use plain
> spin_lock / spin_unlock instead of the irq disabling version.

The rx_bottom() is called in tasklet, so I just think I could use
netif_receive_skb directly. The netif_rx seems to queue the packet,
and local_irq_disable() would be called before dequeuing the skb.
 
Best Regards,
Hayes

