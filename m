Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaIWHHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:07:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:44932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaIWHHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,578,1406617200"; 
   d="scan'208";a="577372207"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        David Miller <davem@davemloft.net>
CC: "rayagond@vayavyalabs.com" <rayagond@vayavyalabs.com>,
        "vbridgers2013@gmail.com" <vbridgers2013@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "tobias.johannes.klausmann@mni.thm.de" 
	<tobias.johannes.klausmann@mni.thm.de>
Subject: RE: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
Thread-Topic: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
Thread-Index: AQHP1pHhFepY2RdQhkeVpgdU2wwwn5wN2aRw///dKYCAAIehAA==
Date: Tue, 23 Sep 2014 07:03:46 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B7EAF23@PGSMSX102.gar.corp.intel.com>
References: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
 <20140922.141921.577008114679288180.davem@davemloft.net>
 <F54AEECA5E2B9541821D670476DAE19C2B7EAE19@PGSMSX102.gar.corp.intel.com>
 <54210EC1.9070507@st.com>
In-Reply-To: <54210EC1.9070507@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Giuseppe CAVALLARO [mailto:peppe.cavallaro@st.com]
> Sent: Tuesday, September 23, 2014 2:10 PM
> 
> the logic is: the priv->stmmac_clk must be always provided from the platform
> then we have two cases:
> 
> 1) if priv->plat->clk_csr is also passed then it will be adopt in the
>     mdio functions to program the Reg4[5:2]
>     This was required in the past IIRC on SPEAr platforms.
> 
> 2) if priv->plat->clk_csr is not passed from the platform then the
>     priv->clk_csr will be set according to the priv->stmmac_clk
>     and always used in the mdio part.
> 
> So IIUC now you are asking for not passing the priv->stmmac_clk and warning
> this event w/o failing. Why you cannot pass this clock?
> 
> peppe


Hi peppe,

Appreciate for the explanation. Just to clarify that I am not asking not to pass in the priv->stmmac_clk.
In fact, the fix will fail at case 2 if driver cannot obtain the priv->stmmac_clk, but just not the case 1.
For case 1, seem like it does not require the stmmac_clk then I think it should be OK not to fail it when
driver did not get stmmac_clk but have the clk_csr set.

Anyway, I can change the fix by adding the clock registration APIs being call at the stmmac_pci.c probe there before
calling stmmac_dvr_probe. By doing this, it created a dependency to the pci driver that must have CONFIG_HAVE_CLK
to be turned on. Besides, I would need you guys to provide me information on other platforms about what is the best 
value to set? Can I just set to zero since the stmmac_pci driver is always using the priv->plat->clk_csr?


Regards,
Wilson

