Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3FCNJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:09:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56835 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3FCNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:08:55 -0400
Message-ID: <1370264933.24311.130.camel@edumazet-glaptop>
Subject: Re: [PATCH v8 net-next 3/7] udp: add low latency socket poll support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 03 Jun 2013 06:08:53 -0700
In-Reply-To: <20130603080138.18273.40991.stgit@ladj378.jer.intel.com>
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>
	 <20130603080138.18273.40991.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 11:01 +0300, Eliezer Tamir wrote:
> Add upport for busy-polling on UDP sockets.
> In __udp[46]_lib_rcv add a call to sk_mark_ll() to copy the napi_id
> from the skb into the sk.
> This is done at the earliest possible moment, right after we identify
> which socket this skb is for.
> In __skb_recv_datagram When there is no data and the user
> tries to read we busy poll.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>


