Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3KEMqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:46:24 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38529 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3KEMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:46:22 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rA5CkEDJ019481, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, "'nic_swsd'" <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1383117220-893-3-git-send-email-hayeswang@realtek.com><20131030.170441.2031802071448773661.davem@davemloft.net><3FC2D94481C34A40A55B033CB9CFA9FB@realtek.com.tw> <20131104.155320.2172500441669637943.davem@davemloft.net>
Subject: RE: [PATCH net v2 2/3] r8152: modify the tx flow
Date: Tue, 5 Nov 2013 20:46:14 +0800
Message-ID: <5D02552B27BB4305AA91C0EFE0344CE2@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac7Zn+iV8+8NvxOeRiqzxrgsiojKGwAhEPMA
In-Reply-To: <20131104.155320.2172500441669637943.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [mailto:davem@davemloft.net] 
> Sent: Tuesday, November 05, 2013 4:53 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; nic_swsd; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net v2 2/3] r8152: modify the tx flow
[...]
> The more TX work you push into the workqueue handler, the longer the
> latency for releasing the SKB and releasing all the queues that are
> waiting for release of that packet.
> 
> Do you know that sockets, queueing discplines, etc. all rely upon
> there being a timely release of SKBs once they are successfully
> transmitted?  It must happen at the earliest moment possible that
> can be reasonable obtained.

Thanks for your answer. I would resend the patches after finishing the
setting of the queue length.

