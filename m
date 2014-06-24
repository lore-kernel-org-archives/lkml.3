Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaFXMW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:22:59 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33515 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXMW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:22:57 -0400
Message-ID: <53A96D68.8070303@gmail.com>
Date: Tue, 24 Jun 2014 17:52:00 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v6 1/7] phy: add a driver for the Berlin SATA PHY
References: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com> <1402914392-6028-2-git-send-email-antoine.tenart@free-electrons.com> <53A9685E.9090501@ti.com> <53A96A1C.5030800@gmail.com> <20140624121525.GM13803@lee--X1>
In-Reply-To: <20140624121525.GM13803@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 05:45 PM, Lee Jones wrote:
> On Tue, 24 Jun 2014, Varka Bhadram wrote:
>> On 06/24/2014 05:30 PM, Kishon Vijay Abraham I wrote:
>>> On Monday 16 June 2014 03:56 PM, Antoine Ténart wrote:
>>>> The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
>>>>
>>>> The mode selection can let us think this PHY can be configured to fit
>>>> other purposes. But there are reasons to think the SATA mode will be
>>>> the only one usable: the PHY registers are only accessible indirectly
>>>> through two registers in the SATA range, the PHY seems to be integrated
>>>> and no information tells us the contrary. For these reasons, make the
>>>> driver a SATA PHY driver.
>>>>
>>>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>>>> ---
>>>>   drivers/phy/Kconfig           |   7 ++
>>>>   drivers/phy/Makefile          |   1 +
>>>>   drivers/phy/phy-berlin-sata.c | 232 ++++++++++++++++++++++++++++++++++++++++++
>>>>   3 files changed, 240 insertions(+)
>>>>   create mode 100644 drivers/phy/phy-berlin-sata.c

[...]

>>>> +static struct platform_driver phy_berlin_sata_driver = {
>>>> +	.probe	= phy_berlin_sata_probe,
>>>> +	.driver	= {
>>>> +		.name		= "phy-berlin-sata",
>>>> +		.owner		= THIS_MODULE,
>>>> +		.of_match_table	= phy_berlin_sata_of_match,
>> use of_match_ptr for of_match_table
> What use is this?
>
> [...]
>
of_match_table is NULL for Non-DT based. Better to use the of_match_ptr().
If driver is DT based 'of_match_table	= phy_berlin_sata_of_match'
else 'of_match_table	= NULL'

This is take care by of_match_ptr() macro.

Thanks,
Varka Bhadram


