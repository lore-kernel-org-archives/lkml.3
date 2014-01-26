Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaAZDDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:03:53 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:32835 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaAZDDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:03:51 -0500
Message-ID: <52E47B51.3030308@gmail.com>
Date: Sat, 25 Jan 2014 19:04:49 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: rob.herring@calxeda.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] of: make of_get_phy_mode parse 'phy-connection-type'
References: <20131114074711.9A8C5C402E1@trevor.secretlab.ca> < 1384496612-28392-1-git-send-email-f.fainelli@gmail.com> <20131116122451.3F0B9C4038F@trevor.secretlab.ca>
In-Reply-To: <20131116122451.3F0B9C4038F@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/11/2013 04:24, Grant Likely a écrit :
> On Fri, 15 Nov 2013 06:23:32 +0000, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> Per the ePAPR v1.1 specification, 'phy-connection-type' is the canonical
>> property name for describing an Ethernet to PHY connection type. Make
>> sure that of_get_phy_mode() also attempts to parse that property and
>> update the comments mentioning 'phy-mode' to also include
>> 'phy-connection-type'.
>>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>
> Applied, thanks

Grant, where is that patch, and will it be part of a pull request to 3.14?

Thanks!

>
> g.
>
>> ---
>> Changes since v2:
>> - reworked the error condition to look nicer per Grant's suggestion
>> - added Grant's Acked-by tag
>> - fixed a typo in the commit message on "mentioning"
>>
>>   drivers/of/of_net.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
>> index 8f9be2e..651e249 100644
>> --- a/drivers/of/of_net.c
>> +++ b/drivers/of/of_net.c
>> @@ -13,8 +13,8 @@
>>
>>   /**
>>    * It maps 'enum phy_interface_t' found in include/linux/phy.h
>> - * into the device tree binding of 'phy-mode', so that Ethernet
>> - * device driver can get phy interface from device tree.
>> + * into the device tree binding of 'phy-mode' or 'phy-connection-type',
>> + * so that Ethernet device driver can get phy interface from device tree.
>>    */
>>   static const char *phy_modes[] = {
>>   	[PHY_INTERFACE_MODE_NA]		= "",
>> @@ -36,8 +36,9 @@ static const char *phy_modes[] = {
>>    * of_get_phy_mode - Get phy mode for given device_node
>>    * @np:	Pointer to the given device_node
>>    *
>> - * The function gets phy interface string from property 'phy-mode',
>> - * and return its index in phy_modes table, or errno in error case.
>> + * The function gets phy interface string from property 'phy-mode' or
>> + * 'phy-connection-type', and return its index in phy_modes table, or errno in
>> + * error case.
>>    */
>>   int of_get_phy_mode(struct device_node *np)
>>   {
>> @@ -46,6 +47,8 @@ int of_get_phy_mode(struct device_node *np)
>>
>>   	err = of_property_read_string(np, "phy-mode", &pm);
>>   	if (err < 0)
>> +		err = of_property_read_string(np, "phy-connection-type", &pm);
>> +	if (err < 0)
>>   		return err;
>>
>>   	for (i = 0; i < ARRAY_SIZE(phy_modes); i++)
>> --
>> 1.8.3.2
>>
>

