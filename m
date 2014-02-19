Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaBSMpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:45:50 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33302 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaBSMpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:45:49 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1JCjeSu029778, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1392731351-25502-1-git-send-email-hayeswang@realtek.com> <1392731351-25502-13-git-send-email-hayeswang@realtek.com> <20140218232850.GB13394@electric-eye.fr.zoreil.com> <79F93FE4FECD48E7B7B6C6EE93151CB6@realtek.com.tw> <20140219074633.GA26271@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 12/14] r8152: replace netif_rxwithnetif_receive_skb
Date: Wed, 19 Feb 2014 20:45:41 +0800
Message-ID: <45593A6C899E4D8E9C76A16474CA1D90@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20140219074633.GA26271@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Thread-Index: Ac8tRrjkrDv9to8NQC2iXeeMF1tgowAJ2S5g
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, February 19, 2014 3:47 PM
> To: hayeswang
> Cc: netdev@vger.kernel.org; nic_swsd@realtek.com; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net-next 12/14] r8152: replace 
> netif_rxwithnetif_receive_skb
> 
[...]
> The change in rx_bottom is fine. My point is about read_bulk_callback.
> 
> rx_bottom races with read_bulk_callback. rx_bottom is issued in
> tasklet (softirq) context. read_bulk_callback is issued in irq
> context, with irq disabled. read_bulk_callback does not need to
> disable irq itself and could go with spin_lock in place of
> spin_lock_irqsave (rx_bottom can't, of course).

I think I misunderstand your meaning.
I would modify them. Thanks.
 
Best Regards,
Hayes

