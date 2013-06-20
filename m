Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3FTGFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:05:20 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47478 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3FTGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:05:18 -0400
Message-ID: <1371708312.3252.359.camel@edumazet-glaptop>
Subject: Re: [net-next rfc 1/3] net: avoid high order memory allocation for
 queues by using flex array
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        edumazet@google.com, hkchu@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Jun 2013 23:05:12 -0700
In-Reply-To: <51C28FA7.2070901@redhat.com>
References: <1371620452-49349-1-git-send-email-jasowang@redhat.com>
	  <1371620452-49349-2-git-send-email-jasowang@redhat.com>
	  <1371623518.3252.267.camel@edumazet-glaptop>
	  <20130619091132.GA2816@redhat.com>
	 <1371635763.3252.289.camel@edumazet-glaptop> <51C28FA7.2070901@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 13:14 +0800, Jason Wang wrote:

> A drawback of NETIF_F_LLTX is that we may contend on qdisc lock
> especially when we have a huge number of tx queues.

For your information loopback driver is LLTX, and there is no qdisc on
it, unless you specifically add one.

Once you add a qdisc on a device, you hit the typical contention on a
spinlock. But its hard to design a parallel qdisc. So far nobody did
that.



