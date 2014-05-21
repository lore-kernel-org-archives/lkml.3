Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaEUWD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:03:26 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46366 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaEUWDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <537D20EA.1000305@cogentembedded.com>
References: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com>
 <1400708331-18088-5-git-send-email-f.fainelli@gmail.com> <537D20EA.1000305@cogentembedded.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 21 May 2014 15:02:42 -0700
Message-ID: <CAGVrzcbBQFhw-dUh+tFm8H5m9-fmVgutChS8wUG-F6sTBoRq-g@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 4/9] net: systemport: use the new fixed
 PHY helpers
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-21 14:55 GMT-07:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> On 05/22/2014 01:38 AM, Florian Fainelli wrote:
>
>> of_phy_connect_fixed_link() is becoming obsolete, and also required
>> platform code to register the fixed PHYs at the specified addresses for
>> those to be usable. Get rid of it and use the new of_phy_is_fixed_link()
>> plus of_phy_register_fixed_link() helpers to transition over the new
>> scheme.
>
>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/net/ethernet/broadcom/bcmsysport.c | 17 +++++++++++++++--
>>   drivers/net/ethernet/broadcom/bcmsysport.h |  1 +
>>   2 files changed, 16 insertions(+), 2 deletions(-)
>
>
>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c
>> b/drivers/net/ethernet/broadcom/bcmsysport.c
>> index d40c5b969e9e..dc708a888f80 100644
>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
>> @@ -1327,8 +1327,8 @@ static int bcm_sysport_open(struct net_device *dev)
>>         /* Read CRC forward */
>>         priv->crc_fwd = !!(umac_readl(priv, UMAC_CMD) & CMD_CRC_FWD);
>>
>> -       priv->phydev = of_phy_connect_fixed_link(dev,
>> bcm_sysport_adj_link,
>> -
>> priv->phy_interface);
>> +       priv->phydev = of_phy_connect(dev, priv->phy_dn,
>> bcm_sysport_adj_link,
>> +                                       0, priv->phy_interface);
>
>
>    The continuation line should start on the next character after ( on the
> above line, according to the networking coding style.

Unless I am once again not following the coding style, the patch in
patchwork has this correctly, and so does my file locally:

http://patchwork.ozlabs.org/patch/351323/
-- 
Florian
