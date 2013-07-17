Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3GQUN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:13:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:27560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab3GQUN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,687,1367996400"; 
   d="scan'208";a="372009056"
Message-ID: <1374092034.7622.34.camel@envy.home>
Subject: Re: [PATCH 3/3] pch_gbe: Add MinnowBoard support
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 17 Jul 2013 13:13:54 -0700
In-Reply-To: <ad20133699c36bd8d183dd685f1b35f6d6b99005.1373676797.git.dvhart@linux.intel.com>
References: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
	 <ad20133699c36bd8d183dd685f1b35f6d6b99005.1373676797.git.dvhart@linux.intel.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 17:58 -0700, Darren Hart wrote:
> The MinnowBoard uses an AR803x PHY with the PCH GBE which requires
> special handling. Use the MinnowBoard PCI Subsystem ID to detect this
> and add a pci_device_id.driver_data structure and functions to handle
> platform setup.
> 
> The AR803x does not implement the RGMII 2ns TX clock delay in the trace
> routing nor via strapping. Add a detection method for the board and the
> PHY and enable the TX clock delay via the registers.
> 
> This PHY will hibernate without link for 10 seconds. Ensure the PHY is
> awake for probe and then disable hibernation. A future improvement would
> be to convert pch_gbe to using PHYLIB and making sure we can wake the
> PHY at the necessary times rather than permanently disabling it.

If anyone is following along to see where this goes, I have made this
change independent of the minnowboard platform drivers and have resent
it with all the collected feedback on to netdev following the netdev
rules I was recently made aware of. Please follow along there if you are
interested.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


