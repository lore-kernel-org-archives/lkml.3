Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaIXGKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:10:07 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:33052 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbaIXGKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:10:05 -0400
Message-ID: <54226020.50008@st.com>
Date: Wed, 24 Sep 2014 08:09:36 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        David Miller <davem@davemloft.net>
Cc: "rayagond@vayavyalabs.com" <rayagond@vayavyalabs.com>,
        "vbridgers2013@gmail.com" <vbridgers2013@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "tobias.johannes.klausmann@mni.thm.de" 
	<tobias.johannes.klausmann@mni.thm.de>
Subject: Re: [PATCH] net: stmmac: fix stmmac_pci_probe failed when CONFIG_HAVE_CLK
 is selected
References: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com> <20140922.141921.577008114679288180.davem@davemloft.net> <F54AEECA5E2B9541821D670476DAE19C2B7EAE19@PGSMSX102.gar.corp.intel.com> <54210EC1.9070507@st.com> <F54AEECA5E2B9541821D670476DAE19C2B7EAF23@PGSMSX102.gar.corp.intel.com>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B7EAF23@PGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.72]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_04:2014-09-23,2014-09-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2014 9:03 AM, Kweh, Hock Leong wrote:
>> -----Original Message-----
>> From: Giuseppe CAVALLARO [mailto:peppe.cavallaro@st.com]
>> Sent: Tuesday, September 23, 2014 2:10 PM
>>
>> the logic is: the priv->stmmac_clk must be always provided from the platform
>> then we have two cases:
>>
>> 1) if priv->plat->clk_csr is also passed then it will be adopt in the
>>      mdio functions to program the Reg4[5:2]
>>      This was required in the past IIRC on SPEAr platforms.
>>
>> 2) if priv->plat->clk_csr is not passed from the platform then the
>>      priv->clk_csr will be set according to the priv->stmmac_clk
>>      and always used in the mdio part.
>>
>> So IIUC now you are asking for not passing the priv->stmmac_clk and warning
>> this event w/o failing. Why you cannot pass this clock?
>>
>> peppe
>
>
> Hi peppe,
>
> Appreciate for the explanation. Just to clarify that I am not asking not to pass in the priv->stmmac_clk.
> In fact, the fix will fail at case 2 if driver cannot obtain the priv->stmmac_clk, but just not the case 1.
> For case 1, seem like it does not require the stmmac_clk then I think it should be OK not to fail it when
> driver did not get stmmac_clk but have the clk_csr set.

ok we can do that but this clock is also managed when the iface is down.
Maybe it could be convenient to manage it for power consumption.
What do you think?

> Anyway, I can change the fix by adding the clock registration APIs being call at the stmmac_pci.c probe there before
> calling stmmac_dvr_probe. By doing this, it created a dependency to the pci driver that must have CONFIG_HAVE_CLK
> to be turned on. Besides, I would need you guys to provide me information on other platforms about what is the best
> value to set? Can I just set to zero since the stmmac_pci driver is always using the priv->plat->clk_csr?
>
>
> Regards,
> Wilson
>
>
>

