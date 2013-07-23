Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3GWGKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 02:10:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43906 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3GWGKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 02:10:31 -0400
Message-ID: <1374559827.4990.143.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
        Oliver Neukum <oliver@neukum.org>
Cc: Grant Grundler <grundler@google.com>, Freddy Xin <freddy@asix.com.tw>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ASIX Louis =?UTF-8?Q?=5B=E8=98=87=E5=A8=81=E9=99=B8=5D?= 
	<louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>
Date: Mon, 22 Jul 2013 23:10:27 -0700
In-Reply-To: <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	 <1374512879.4990.19.camel@edumazet-glaptop>
	 <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
	 <1374518312.1635.29.camel@bwh-desktop.uk.level5networks.com>
	 <1374518841.4990.26.camel@edumazet-glaptop>
	 <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 20:47 +0100, Ben Hutchings wrote:
> On Mon, 2013-07-22 at 11:47 -0700, Eric Dumazet wrote:
> > On Mon, 2013-07-22 at 19:38 +0100, Ben Hutchings wrote:
> > > On Mon, 2013-07-22 at 11:29 -0700, Grant Grundler wrote:
> > > > On Mon, Jul 22, 2013 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > > ...
> > > > > I guess that if a driver does not advertise NETIF_F_SG, this
> > > > > skb_linearize() call is not needed : All frames reaching your xmit
> > > > > function should already be linear
> > > > 
> > > > As Ben Hutchings pointed out, hw_features is still setting this...but
> > > > I'm not sure how that matters.
> > > > 
> > > > ax88179_set_features() doesn't allow setting SG or TSO features.  But
> > > > I expect it would be "not too difficult" to add such that ethtool
> > > > could set those features after boot.
> > > [...]
> > > 
> > > It already can.  That's what putting feature flags in hw_features does.
> > 
> > My original concern, that inspired this patch, was to remove SG support,
> > as this driver does not have SG support at all.
> > 
> > Linearize a full TSO packet needs order-5 allocations, thats likely to
> > fail and lead to very slow TCP performance, because it will only rely on
> > retransmits.
> 
> The driver could set gso_max_size to reduce that problem.  But I rather
> doubt that TSO followed by skb_linearize() significantly improves
> throughput or CPU-efficiency.  (If the device has a 1G link but is
> connected to the host through a USB 2.0 port, then USB is the bottleneck
> and TSO could improve throughput a few percent.  But that's a silly
> configuration.)
> 
> The real solution would be for someone to add SG support to the usbnet
> core.  Trying to support 1GbE with only linear skbs is not a great
> idea... and it can only be a matter of time before there is USB ultra
> speed (or whatever comes after 'super') with 10GbE devices...
> 

This sounds a good idea.

Is anybody working on adding SG to usbnet ?



