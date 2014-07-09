Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaGIWKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:10:08 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:47580 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaGIWKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:10:06 -0400
Date: Thu, 10 Jul 2014 00:09:54 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH net v2] r8169: disable L23
Message-ID: <20140709220954.GA30848@electric-eye.fr.zoreil.com>
References: <1394712342-15778-6-Taiwan-albertk@realtek.com>
 <1394712342-15778-7-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-7-Taiwan-albertk@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> For RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106, disable the feature
> of entering the L2/L3 link state of the PCIe. When the nic starts the process
> of entering the L2/L3 link state and the PCI reset occurs before the work
> is finished, the work would be queued and continue after the next the PCI
> reset occurs. This causes the device stays in L2/L3 link state, and the system
> couldn't find the device.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

Thanks, the explanation of the race between software induced PCI reset
and transition to PCIe L2/L3 should be clear enough. PM scared me, yet
it got worse.

Davem, would you mind to s/rtl_l23_enable/rtl_pcie_state_l2l3_enable/ or
do you want a new patch for it ?

-- 
Ueimor
