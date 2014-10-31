Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbaJaMYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:24:17 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35448 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbaJaMYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:24:16 -0400
Message-ID: <1414758253.499.8.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] virtio_net: fix use after free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Date: Fri, 31 Oct 2014 05:24:13 -0700
In-Reply-To: <5453270F.3090300@redhat.com>
References: <1413378878-28118-1-git-send-email-mst@redhat.com>
	 <1414726609.499.6.camel@edumazet-glaptop2.roam.corp.google.com>
	 <5453270F.3090300@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 14:07 +0800, Jason Wang wrote:

> Since they are called before the possible free_old_xmit_skbs(), skb
> won't get freed at this time.

Oh right, I forgot there is no completion handler yet, timer based or
whatever.

Thanks.

