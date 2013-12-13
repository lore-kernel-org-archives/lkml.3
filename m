Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3LMKhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:37:17 -0500
Received: from mx0.aculab.com ([213.249.233.131]:60732 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752353Ab3LMKhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:37:13 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether reserving NET_IP_ALIGN bytes for an SKB.
Date: Fri, 13 Dec 2013 10:36:01 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B748A@saturn3.aculab.com>
In-Reply-To: <1386926708-2343-1-git-send-email-freddy@asix.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether reserving NET_IP_ALIGN bytes for an SKB.
Thread-Index: Ac736Qry30ww57JVTj2u+xZ1j+766AABSvLw
References: <1386926708-2343-1-git-send-email-freddy@asix.com.tw>
From: "David Laight" <David.Laight@ACULAB.COM>
To: <freddy@asix.com.tw>, <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <louis@asix.com.tw>, <allan@asix.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: freddy@asix.com.tw
...
> -	skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);
> +	if (dev->driver_info->flags & FLAG_HW_IPALIGN)
> +		skb = __netdev_alloc_skb(dev->net, size, flags);
> +	else
> +		skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);

Given the definition:
static inline struct sk_buff *__netdev_alloc_skb_ip_align(struct net_device *dev,
                unsigned int length, gfp_t gfp)
{
        struct sk_buff *skb = __netdev_alloc_skb(dev, length + NET_IP_ALIGN, gfp);

        if (NET_IP_ALIGN && skb)
                skb_reserve(skb, NET_IP_ALIGN);
        return skb;
}

It really ought to be possible to code that without an extra conditional.

	David



