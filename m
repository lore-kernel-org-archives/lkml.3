Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaHHFsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:48:08 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45746 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaHHFsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:48:04 -0400
Message-ID: <1407476878.3604.0.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Weird NET_RX softirq behavior
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Dmitry Popov <ixaphire@qrator.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 08 Aug 2014 07:47:58 +0200
In-Reply-To: <20140808103734.677bff7e@xhacker>
References: <20140807171050.77819b10@xhacker>
	 <20140807181813.37b73927513266381d55ad0d@qrator.net>
	 <20140808103734.677bff7e@xhacker>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 10:37 +0800, Jisheng Zhang wrote:
> nd and recive 7 packets so far, about 1400bytes. Seems small
> comparing with the CPU1 and CPU2 NET_RX softirq numbers, right?
> 
> Any other possible case?

Multicast loop. Check dev_loopback_xmit() and its callers.


