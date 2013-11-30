Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3K3Wlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:53 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64304 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3K3WlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:41:08 -0500
Message-ID: <529A6982.1090206@gmail.com>
Date: Sat, 30 Nov 2013 23:41:06 +0100
From: =?UTF-8?B?T25kxZllaiBQdcW+bWFu?= <puzman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pch_gbe: Fix transmit queue management
References: <20131127.203929.1379316258754767343.davem@davemloft.net>	<1385631882-12827-2-git-send-email-puzman@gmail.com> <20131129.164229.2292905485668904870.davem@davemloft.net>
In-Reply-To: <20131129.164229.2292905485668904870.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please format your commit  message text to 80 columns.

Ok, no problem. I did not know that 80 columns limitation applies also
for commit messages.

> You should be instead  preventing the transmit method from being
> invoked when it might be possible that a request cannot be
> satisfied. This means that at the end of a transmit request, you must
> stop the queue if a packet with the maximum number of possible
> descriptors cannot be satisfied. Then it is impossible for the
> transmit function to be invoked in a situation where it would need to
> fail for lack of available transmit descriptors. This is why drivers
> decided whether to stop their TX queues based upon calculations
> involving MAX_SKB_FRAGS.

Hmm, correct me if I'm wrong ... but the driver and hardware does not
support scatter-gather DMA. So fragmented skbs can't be passed to
ndo_start_xmit function and each skb passed to the function represents
one packet and one descriptor in tx_ring.
I do not think that in this caseit makes sense to to involve
MAX_SKB_FRAGS in any calculation and the queue should be stopped in the
moment when it gets full.
But maybe I am missing something, I am no expert in this kind of stuff.

--
Ondrej Puzman

