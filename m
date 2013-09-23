Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3IWPyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:54:33 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:53332 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab3IWPyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:54:31 -0400
X-IronPort-AV: E=Sophos;i="4.90,963,1371074400"; 
   d="scan'208";a="33997898"
Date: Mon, 23 Sep 2013 17:54:00 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: andy@greyhouse.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: question tehuti.c
Message-ID: <alpine.DEB.2.02.1309231752040.2242@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function bdx_setmulti in the file drivers/net/ethernet/tehuti/tehuti.c
contains:

        u32 rxf_val =
            GMAC_RX_FILTER_AM | GMAC_RX_FILTER_AB | GMAC_RX_FILTER_OSEN;

and then later:

       } else {
                DBG("only own mac %d\n", netdev_mc_count(ndev));
                rxf_val |= GMAC_RX_FILTER_AB;
        }

The last assignment doesn't look very useful, because GMAC_RX_FILTER_ABis
already included in rxf_val.  Was something else intended?

thanks,
julia
