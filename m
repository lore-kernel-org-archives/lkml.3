Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3HKJ4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 05:56:18 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3630 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805Ab3HKJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 05:56:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,855,1367964000"; 
   d="scan'208";a="23705717"
Date: Sun, 11 Aug 2013 11:56:09 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: romieu@fr.zoreil.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: question about netif_rx
Message-ID: <alpine.DEB.2.02.1308111151210.2072@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To my limited understanding, in a NAPI polling function, one should use 
netif_receive_skb, rather than netif_rx.  However, the via-velocity driver 
defines the NAPI polling function velocity_poll, which is the only caller 
of velocity_rx_srv, which is the only caller of velocity_receive_frame, 
which calls netif_rx.  The call to netif_rx seems to predate the 
introduction of NAPI in this driver.  Is this correct?

thanks,
julia
