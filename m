Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaKUVqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:46:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:16657 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaKUVq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:46:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,433,1413270000"; 
   d="scan'208";a="626403517"
From: "Sullivan, Catherine" <catherine.sullivan@intel.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "Nelson, Shannon" <shannon.nelson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: i40e/i40e_ethtool.c weirdness?
Thread-Topic: i40e/i40e_ethtool.c weirdness?
Thread-Index: AQHQBPdzPUcP5tCSpUa6m2utVfrfB5xrnhog
Date: Fri, 21 Nov 2014 21:46:05 +0000
Message-ID: <E8A77B2FB54C194393A5C2A8E3ED167808B3F535@CRSMSX102.amr.corp.intel.com>
References: <51793.1416511307@turing-police.cc.vt.edu>
In-Reply-To: <51793.1416511307@turing-police.cc.vt.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.18.205.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis Kletnieks [mailto:Valdis.Kletnieks@vt.edu]
> 
> (spotted while looking at a 'git bisect visualize' for something else)
> 
> After this commit:
> 
> Author: Mitch Williams <mitch.a.williams@intel.com>  2014-09-13 03:40:47
> Committer: Jeff Kirsher <jeffrey.t.kirsher@intel.com>  2014-10-23 23:38:04
> 
>     i40e: Add 10GBaseT support
> 
>     Add driver support for 10GBaseT device.
> 
> we have the following chunk of code in i40e_ethtool.c:
> 
>         case I40E_PHY_TYPE_10GBASE_SFPP_CU:
>                 ecmd->supported = SUPPORTED_10000baseT_Full;
>                 break;
>         case I40E_PHY_TYPE_1000BASE_KX:
>         case I40E_PHY_TYPE_1000BASE_T:
>                 ecmd->supported = SUPPORTED_Autoneg |
>                                   SUPPORTED_10000baseT_Full |
>                                   SUPPORTED_1000baseT_Full |
>                                   SUPPORTED_100baseT_Full;
>                 ecmd->advertising = ADVERTISED_Autoneg |
>                                     ADVERTISED_10000baseT_Full |
>                                     ADVERTISED_1000baseT_Full |
>                                     ADVERTISED_100baseT_Full;
>                 break;
>         case I40E_PHY_TYPE_100BASE_TX:
>                 ecmd->supported = SUPPORTED_Autoneg |
>                                   SUPPORTED_10000baseT_Full |
>                                   SUPPORTED_1000baseT_Full |
>                                   SUPPORTED_100baseT_Full;
>                 ecmd->advertising = ADVERTISED_Autoneg |
>                                     ADVERTISED_10000baseT_Full |
>                                     ADVERTISED_1000baseT_Full |
>                                     ADVERTISED_100baseT_Full;
>                 break;
>         case I40E_PHY_TYPE_SGMII:
>                 ecmd->supported = SUPPORTED_Autoneg |
> 
> I'm confused by the fact that 2 cases that by name are 100M and 1G parts got
> bits saying that 10G is "supported" - was that intentional?

Yes, it was intentional. The 100M and 1G phy types that got 10G support are actually 10G parts that show up as 100M and 1G when that is the link speed. All three phy types therefore need to support all three speeds so that it is possible to toggle between them. 

-Catherine
