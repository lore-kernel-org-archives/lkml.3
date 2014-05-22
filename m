Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaEVVDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:03:30 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58169 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEVVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:03:29 -0400
Message-ID: <1400792601.5367.176.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: skbuff truesize incorrect.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jim Baxter <jim_baxter@mentor.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kamal@canonical.com,
        Ben Hutchings <bhutchings@solarflare.com>, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Date: Thu, 22 May 2014 14:03:21 -0700
In-Reply-To: <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
References: <537E4AFD.20304@mentor.com>
	 <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 13:58 -0700, Eric Dumazet wrote:

> I would set rx_max (rx_urb_size) to SKB_MAX_HEAD(0) so that you do not
> use high order allocations.

Correction, that would need SKB_MAX_HEAD(NET_SKB_PAD + NET_IP_ALIGN),
because drivers/net/usb/usbnet.c calls __netdev_alloc_skb_ip_align().



