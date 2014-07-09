Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaGIXmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:42:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34612 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885AbaGIXmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:42:43 -0400
Date: Wed, 09 Jul 2014 16:42:38 -0700 (PDT)
Message-Id: <20140709.164238.899320392607428223.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net v2] r8169: disable L23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140709220954.GA30848@electric-eye.fr.zoreil.com>
References: <1394712342-15778-6-Taiwan-albertk@realtek.com>
	<1394712342-15778-7-Taiwan-albertk@realtek.com>
	<20140709220954.GA30848@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 09 Jul 2014 16:42:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Thu, 10 Jul 2014 00:09:54 +0200

> Hayes Wang <hayeswang@realtek.com> :
>> For RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106, disable the feature
>> of entering the L2/L3 link state of the PCIe. When the nic starts the process
>> of entering the L2/L3 link state and the PCI reset occurs before the work
>> is finished, the work would be queued and continue after the next the PCI
>> reset occurs. This causes the device stays in L2/L3 link state, and the system
>> couldn't find the device.
>> 
>> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>
> 
> Thanks, the explanation of the race between software induced PCI reset
> and transition to PCIe L2/L3 should be clear enough. PM scared me, yet
> it got worse.
> 
> Davem, would you mind to s/rtl_l23_enable/rtl_pcie_state_l2l3_enable/ or
> do you want a new patch for it ?

Applied with the function name adjusted, thanks.
