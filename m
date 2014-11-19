Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaKSTxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:53:24 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:61918 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaKSTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:53:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141119.144604.269852847904624488.davem@davemloft.net>
References: <1416288041-30921-1-git-send-email-jasowang@redhat.com>
	<CAHA+R7O=vCtLwUPnkVpymxc9kp+a8ChS2MHAJahfJUNUdLX89A@mail.gmail.com>
	<546C0B58.5030402@redhat.com>
	<20141119.144604.269852847904624488.davem@davemloft.net>
Date: Wed, 19 Nov 2014 11:53:22 -0800
Message-ID: <CAHA+R7MfRHGbahL5ah24_W-f6c5WTTqANBaWTtdMDAyhvprZKw@mail.gmail.com>
Subject: Re: [PATCH net-next] tun: return NET_XMIT_DROP for dropped packets
From: Cong Wang <cwang@twopensource.com>
To: David Miller <davem@davemloft.net>
Cc: Jason Wang <jasowang@redhat.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:46 AM, David Miller <davem@davemloft.net> wrote:
>
> Often the issue with TX return values is lack of clear documentation
> and use cases.
>

NET_XMIT_* are marked as qdisc ->enqueue() return codes
in include/linux/netdevice.h, and are indeed used mostly by
qdisc:

$ git grep NET_XMIT_ -- net/sched/ | wc -l
88
$ git grep NET_XMIT_ -- drivers/net/ | wc -l
15

It is a mess. Not to mention we have __NET_XMIT_ code too.
