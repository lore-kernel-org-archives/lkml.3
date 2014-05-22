Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEVRV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:21:27 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:63142 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaEVRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:21:26 -0400
Message-ID: <537E3218.6030104@cogentembedded.com>
Date: Thu, 22 May 2014 21:21:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH RESEND net-next 4/9] net: systemport: use the new fixed
 PHY helpers
References: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com> <1400708331-18088-5-git-send-email-f.fainelli@gmail.com> <537D20EA.1000305@cogentembedded.com> <CAGVrzcbBQFhw-dUh+tFm8H5m9-fmVgutChS8wUG-F6sTBoRq-g@mail.gmail.com>
In-Reply-To: <CAGVrzcbBQFhw-dUh+tFm8H5m9-fmVgutChS8wUG-F6sTBoRq-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/22/2014 02:02 AM, Florian Fainelli wrote:

>>> of_phy_connect_fixed_link() is becoming obsolete, and also required
>>> platform code to register the fixed PHYs at the specified addresses for
>>> those to be usable. Get rid of it and use the new of_phy_is_fixed_link()
>>> plus of_phy_register_fixed_link() helpers to transition over the new
>>> scheme.

>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>    drivers/net/ethernet/broadcom/bcmsysport.c | 17 +++++++++++++++--
>>>    drivers/net/ethernet/broadcom/bcmsysport.h |  1 +
>>>    2 files changed, 16 insertions(+), 2 deletions(-)

>>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c
>>> b/drivers/net/ethernet/broadcom/bcmsysport.c
>>> index d40c5b969e9e..dc708a888f80 100644
>>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
>>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
>>> @@ -1327,8 +1327,8 @@ static int bcm_sysport_open(struct net_device *dev)
>>>          /* Read CRC forward */
>>>          priv->crc_fwd = !!(umac_readl(priv, UMAC_CMD) & CMD_CRC_FWD);
>>>
>>> -       priv->phydev = of_phy_connect_fixed_link(dev,
>>> bcm_sysport_adj_link,
>>> -
>>> priv->phy_interface);
>>> +       priv->phydev = of_phy_connect(dev, priv->phy_dn,
>>> bcm_sysport_adj_link,
>>> +                                       0, priv->phy_interface);

>>     The continuation line should start on the next character after ( on the
>> above line, according to the networking coding style.

> Unless I am once again not following the coding style, the patch in
> patchwork has this correctly, and so does my file locally:

> http://patchwork.ozlabs.org/patch/351323/

    Don't know about your local file but the patchwork still has the 
indentation wrong. -- you've used only tabs while the last several characters 
should have been spaces. However, if David himself finds it correct, I guess I 
just need to shut up. :-)

WBR, Sergei

