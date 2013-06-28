Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3F1FhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:37:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:22199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3F1FhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:37:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,956,1363158000"; 
   d="scan'208";a="336816747"
Message-ID: <1372397822.9243.22.camel@envy.home>
Subject: Re: [PATCH 8/8] pch_gbe: Add MinnowBoard support
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Date: Thu, 27 Jun 2013 22:37:02 -0700
In-Reply-To: <6c27e79870ec93f7a8c6692d4bcfebaee589fa6b.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <6c27e79870ec93f7a8c6692d4bcfebaee589fa6b.1372211451.git.dvhart@linux.intel.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 18:53 -0700, Darren Hart wrote:
> The MinnowBoard uses an AR803x PHY with the PCH GBE.
> 
> It does not implement the RGMII 2ns TX clock delay in the trace routing
> nor via strapping. Add a detection method for the board and the PHY and
> enable the tx clock delay via the registers.
> 
> This PHY will hibernate without link for 10 seconds. Ensure the PHY is
> awake for probe and then disable hibernation. A future improvement would
> be to convert pch_gbe to using PHYLIB and making sure we can wake the
> PHY at the necessary times rather than permanently disabling it.
> 
> Use the MinnowBoard PCI subsystem ID to identify the board and setup the
> appropriate callbacks in a new pci_id driver_data structure.
> 


Per the discussion on the minnowboard platform drivers in this series
(which provide the minnow_phy_reset() function), I will be rewriting
this patch to provide its own phy_physical_reset() or similar which will
look like the other two phy functions I've added and will take a GPIO
line as an argument, determined by pci_id.

Please disregard this patch for now.

Thanks,


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

