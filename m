Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3GYPLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:11:35 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:64177 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:11:32 -0400
Message-ID: <1374765088.23313.21.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Oliver Neukum <oliver@neukum.org>,
        Grant Grundler <grundler@google.com>, Freddy Xin <freddy@asix.com.tw>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ASIX Louis =?UTF-8?Q?=5B=E8=98=87=E5=A8=81=E9=99=B8=5D?= 
	<louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>
Date: Thu, 25 Jul 2013 08:11:28 -0700
In-Reply-To: <CACVXFVNre5SsJhaVqFNRcop7ahqxabWqHZkjBZccj1ZqOAUZ9A@mail.gmail.com>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	 <1374512879.4990.19.camel@edumazet-glaptop>
	 <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
	 <1374518312.1635.29.camel@bwh-desktop.uk.level5networks.com>
	 <1374518841.4990.26.camel@edumazet-glaptop>
	 <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
	 <1374559827.4990.143.camel@edumazet-glaptop>
	 <CACVXFVN0eN9E9efr8UdqFz68-emHa2o-RQ0RYfazEq8f=qxkLQ@mail.gmail.com>
	 <1374729058.23313.8.camel@edumazet-glaptop>
	 <CACVXFVNyFk0Zpi4tC0ENiq8RcrtrjYW-Dhs+A56+Pw4BKm8y8A@mail.gmail.com>
	 <1374750101.23313.16.camel@edumazet-glaptop>
	 <CACVXFVNre5SsJhaVqFNRcop7ahqxabWqHZkjBZccj1ZqOAUZ9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 22:52 +0800, Ming Lei wrote:

> Maybe need to try it with TSO enabled, in my test on ax88179_178a NIC after
> applying your disabling TSO patch, tx throughput is less than 600Mbps, but rx
> is close to 900Mbps.

It looks like TCP stack could for this case allocate linear skbs
(GFP_KERNEL context), using order-3 pages, and not adding frags on them,
to avoid the skb_linearize() hazard (in GFP_ATOMIC)

In case of retransmits, skb are small (one MSS) so the skb_linearize()
should succeed most of the time.



