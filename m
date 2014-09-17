Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaIQEzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:55:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33377 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaIQEzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:55:37 -0400
Date: Wed, 17 Sep 2014 00:55:32 -0400 (EDT)
Message-Id: <20140917.005532.2054822778882237895.davem@davemloft.net>
To: hock.leong.kweh@intel.com
Cc: peppe.cavallaro@st.com, rayagond@vayavyalabs.com, vbridgers2013@gmail.com,
        srinivas.kandagatla@st.com, wens@csie.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, boon.leong.ong@intel.com
Subject: Re: [PATCH v2 3/4] net: stmmac: add support for Intel Quark X1000
From: David Miller <davem@davemloft.net>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B7E9DCA@PGSMSX102.gar.corp.intel.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B7E99A7@PGSMSX102.gar.corp.intel.com>
	<20140916.150037.1715537913178712290.davem@davemloft.net>
	<F54AEECA5E2B9541821D670476DAE19C2B7E9DCA@PGSMSX102.gar.corp.intel.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 21:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Date: Wed, 17 Sep 2014 02:41:39 +0000

> Thanks for the pointer. I did a quickly checking on the class number to see if
> I could use it for differentiation the ports number. Whereas I found them 
> both have the same class number as well. Below shows the "lspci" dump to 
> all the PCI devices on Quark X1000 Galileo board (Ethernet controllers are
> 00:14.6 and 00:14.7). Very unfortunately we are unlikely to use the class 
> number as well as pci_device_id for the differentiation.
 ...
> 00:14.6 "Class 0200" "8086" "0937" "8086" "0937"
> 00:14.7 "Class 0200" "8086" "0937" "8086" "0937"

Are you kidding me?  It's a perfect way to identify this device, it
properly uses PCI_CLASS_NETWORK_ETHERNET (0x0200) in both cases and
this will not match any other function on this PCI device at all.

Please do as I suggested and use the PCI class for the differentiation
and matching during probing.
