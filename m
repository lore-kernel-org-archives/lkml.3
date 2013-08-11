Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3HKP5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 11:57:34 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:42311 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3HKP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 11:57:32 -0400
Date: Sun, 11 Aug 2013 17:56:40 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: question about netif_rx
Message-ID: <20130811155640.GA10070@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> :
> To my limited understanding, in a NAPI polling function, one should use 
> netif_receive_skb, rather than netif_rx.

Nit: or napi_gro_receive (+ napi_gro_flush with __napi_complete) when the
device offers some checksum offloading features.

> However, the via-velocity driver defines the NAPI polling function
> velocity_poll, which is the only caller of velocity_rx_srv, which
> is the only caller of velocity_receive_frame, which calls netif_rx.
> The call to netif_rx seems to predate the introduction of NAPI in
> this driver.  Is this correct?

You are right. It's a leftover of the NAPI changes in this driver.

Can you send a netif_receive_skb replacement patch for it ?

-- 
Ueimor
