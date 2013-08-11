Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3HKQM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:12:56 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:12044
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab3HKQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:12:54 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23716867"
Date: Sun, 11 Aug 2013 18:12:50 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Francois Romieu <romieu@fr.zoreil.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, grant.likely@linaro.org,
        rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: question about netif_rx
In-Reply-To: <20130811155640.GA10070@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1308111811440.2072@localhost6.localdomain6>
References: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6> <20130811155640.GA10070@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Aug 2013, Francois Romieu wrote:

> Julia Lawall <julia.lawall@lip6.fr> :
> > To my limited understanding, in a NAPI polling function, one should use 
> > netif_receive_skb, rather than netif_rx.
> 
> Nit: or napi_gro_receive (+ napi_gro_flush with __napi_complete) when the
> device offers some checksum offloading features.

OK, thanks for the information.  I am just trying to understand these 
functions...

> > However, the via-velocity driver defines the NAPI polling function
> > velocity_poll, which is the only caller of velocity_rx_srv, which
> > is the only caller of velocity_receive_frame, which calls netif_rx.
> > The call to netif_rx seems to predate the introduction of NAPI in
> > this driver.  Is this correct?
> 
> You are right. It's a leftover of the NAPI changes in this driver.
> 
> Can you send a netif_receive_skb replacement patch for it ?

Just to be sure, I just replace netif_rx by netif_receive_skb, nothing
else?

thanks,
julia
