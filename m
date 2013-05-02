Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3EBHrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:47:09 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39707 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3EBHrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:47:07 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.32 with qID r427kpXn018493, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Oliver Neukum'" <oneukum@suse.de>
CC: <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>
References: <1366965948-1805-1-git-send-email-hayeswang@realtek.com> <201305020622.r426MYGv032465@rtits1.realtek.com>
Subject: RE: [PATCH net-next] net/usb: new driver for RTL8152
Date: Thu, 2 May 2013 15:46:50 +0800
Message-ID: <95FC8A7CCB904AB6B26751C6DBEE49F2@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac5G/W7XjE3FA+raS8eFac7xEr4HfAABeegw
In-Reply-To: <201305020622.r426MYGv032465@rtits1.realtek.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Oliver Neukum [mailto:oneukum@suse.de] 
> Sent: Friday, April 26, 2013 7:57 PM
> To: Hayeswang
> Cc: gregkh@linuxfoundation.org; netdev@vger.kernel.org; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; nic_swsd
> Subject: Re: [PATCH net-next] net/usb: new driver for RTL8152
> 
[...]
> > +static inline void set_ethernet_addr(struct r8152 *tp)
> > +{
> > +	struct net_device *dev = tp->netdev;
> > +	u8 node_id[8] = {0};
> > +
> > +	if (pla_ocp_read(tp, PLA_IDR, sizeof(node_id), node_id) < 0)
> 
> DMA coherency rules. No buffers on the stack.

Excuse me. I don't understand what you mean. I reference the rtl8150.c and it
uses the same way. Besides, when I check the other drivers, I find the data
pointer of the parameter of the usb_control_msg() may be a pointer of a local
variable from the other functions.

[...]
> > +static void rtl_work_func_t(struct work_struct *work)
> > +{
> > +	struct r8152 *tp = container_of(work, struct r8152, 
> schedule.work);
> > +
> > +	if (!netif_running(tp->netdev))
> > +		goto out1;
> > +
> > +	if (test_bit(RTL8152_UNPLUG, &tp->flags))
> > +		goto out1;
> > +
> > +	set_carrier(tp);
> > +
> > +	if (test_bit(RTL8152_SET_RX_MODE, &tp->flags))
> > +		_rtl8152_set_rx_mode(tp->netdev);
> > +
> > +	schedule_delayed_work(&tp->schedule, HZ);
> 
> Why does this need to run permanently?

It is used to periodically check the speed, link status, and any other tasks
which need to be finished.

[...]
> > +static int rtl8152_close(struct net_device *netdev)
> > +{
> > +	struct r8152 *tp = netdev_priv(netdev);
> > +	int res = 0;
> > +
> > +	cancel_delayed_work_sync(&tp->schedule);
> 
> Looks like a race. What makes sure the work isn't rescheduled?

netif_running would be checked.

 
Best Regards,
Hayes

