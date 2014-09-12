Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaILGyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:54:24 -0400
Received: from smtp10.online.nl ([194.134.42.55]:60833 "EHLO smtp10.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaILGyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:54:22 -0400
Message-ID: <5412989A.5000905@topic.nl>
Date: Fri, 12 Sep 2014 08:54:18 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/phy: micrel: Disable asymmetric pause for KSZ9031
References: <1410443140-2833-1-git-send-email-mike.looijmans@topic.nl> <5411ECE9.8050600@gmail.com>
In-Reply-To: <5411ECE9.8050600@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Online-Scanned: by Cloudmark authority (on smtp10.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:41 PM, Florian Fainelli wrote:
> On 09/11/2014 06:45 AM, Mike Looijmans wrote:
>> Our KSZ9031 appears to suffer from the same hardware bug as described
>> for the KSZ9021 in commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577,
>> you have to unplug the cable and plug it back to get it to work.
>>
>> Remove the SUPPORTED_Asym_Pause flag for the KSZ9031 to fix this.
>
> Can you resend this patch specifying the commit subject in parenthesis
> like this:
>
> commit 32fcafbcd1c9f6c7013016a22a5369b4acb93577 ("net/phy: micrel:
> Disable asymmetric pause for KSZ9021")

I'll amend the text body and resend the patch.

> since this is a bugfix, it should probably be targeting the 'net' tree,
> rather than the 'net-next' tree, though the patch applies to both cleanly.

I assume this does not require any action on my side? I actually based 
this patch on a 3.14 kernel.


> Other than that:
>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>> ---
>>   drivers/net/phy/micrel.c |    3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>> index 5a8993b..a932a35 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -425,8 +425,7 @@ static struct phy_driver ksphy_driver[] = {
>>   	.phy_id		= PHY_ID_KSZ9031,
>>   	.phy_id_mask	= 0x00fffff0,
>>   	.name		= "Micrel KSZ9031 Gigabit PHY",
>> -	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause
>> -				| SUPPORTED_Asym_Pause),
>> +	.features	= (PHY_GBIT_FEATURES | SUPPORTED_Pause),
>>   	.flags		= PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
>>   	.config_init	= kszphy_config_init,
>>   	.config_aneg	= genphy_config_aneg,
>>
>


-- 
Mike Looijmans
