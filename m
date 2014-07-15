Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbaGOG66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:58:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45976 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbaGOG6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:58:54 -0400
X-Original-SENDERIP: 10.178.37.74
X-Original-MAILFROM: neidhard.kim@lge.com
Message-ID: <53C4D126.5000005@lge.com>
Date: Tue, 15 Jul 2014 15:58:46 +0900
From: Jongsung Kim <neidhard.kim@lge.com>
Organization: LG Electronics
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "'Varka Bhadram'" <varkabhadram@gmail.com>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] net: cadence: macb: add support for the WOL
References: <1405328538-29153-1-git-send-email-neidhard.kim@lge.com> <53C3ADB9.4010309@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D17271AC1@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17271AC1@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:49 PM, David Laight wrote:
> From: Varka Bhadram
>> On 07/14/2014 02:32 PM, Jongsung Kim wrote:
>>> This patch enables the ethtool utility to control the WOL function
>>> of the PHY connected to the GEM/MACB. (if supported)
> ...
>>> +static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
>>> +{
>>> +	struct macb *bp = netdev_priv(netdev);
>>> +	struct phy_device *phydev = bp->phy_dev;
>>> +	int err = -ENODEV;
>>> +
>>> +	if (phydev)
>>> +		err = phy_ethtool_set_wol(phydev, wol);
>>> +
>>> +	return err;
>>> +}
>>> +
>>
>> I think we can do in this way:
>>
>> if (phydev)
>> 	return phy_ethtool_set_wol(phydev, wol);
>> else
>> 	return -ENODEV;
>>
>>
>> we can save err. What do you say ...?
> 
> I would do:
> 	if (!phydev)
> 		return -ENODEV;
> 	return phy_ethtool_set_wol(phydev, wol);
> 
> Although it might even be worth moving the NULL test into the function.
> (sort of depends on style and the number of callers who need to do the test.)
> 

Totally agreed. I'd be better to submit a patch about it first.

> 	David
> 
> 
> 
> 
