Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaGGOKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:10:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47387 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbaGGOKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:10:21 -0400
Message-ID: <53BAAA19.9050106@ti.com>
Date: Mon, 7 Jul 2014 19:39:29 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <sergei.shtylyov@cogentembedded.com>,
        <antoine.tenart@free-electrons.com>, <kgene.kim@samsung.com>,
        <maxime.ripard@free-electrons.com>
Subject: Re: [RFC PATCH 2/2] phy: core: the node pointer of PHY need not be
 the same as that of PHY provider
References: <1404486474-28312-1-git-send-email-kishon@ti.com> <1404486474-28312-3-git-send-email-kishon@ti.com> <20140707131232.GI6407@lee--X1>
In-Reply-To: <20140707131232.GI6407@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 07 July 2014 06:42 PM, Lee Jones wrote:
> On Fri, 04 Jul 2014, Kishon Vijay Abraham I wrote:
> 
>> In case of multi-phy PHY providers, each PHY should be modeled as a sub
>> node of the PHY provider. Then each PHY will have a different node pointer
>> (node pointer of sub node) than that of PHY provider. Added this provision
>> in the PHY core.
>> Also fixed all drivers to use the updated API.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  Documentation/phy.txt               |   10 ++++++----
>>  drivers/phy/phy-bcm-kona-usb2.c     |    2 +-
>>  drivers/phy/phy-core.c              |   25 ++++++++++++++++++-------
>>  drivers/phy/phy-exynos-dp-video.c   |    2 +-
>>  drivers/phy/phy-exynos-mipi-video.c |    2 +-
>>  drivers/phy/phy-exynos5-usbdrd.c    |    3 ++-
>>  drivers/phy/phy-exynos5250-sata.c   |    2 +-
>>  drivers/phy/phy-mvebu-sata.c        |    2 +-
>>  drivers/phy/phy-omap-usb2.c         |    2 +-
>>  drivers/phy/phy-samsung-usb2.c      |    3 ++-
>>  drivers/phy/phy-sun4i-usb.c         |    2 +-
>>  drivers/phy/phy-ti-pipe3.c          |    2 +-
>>  drivers/phy/phy-twl4030-usb.c       |    2 +-
>>  drivers/phy/phy-xgene.c             |    2 +-
>>  include/linux/phy/phy.h             |   15 ++++++++++-----
>>  15 files changed, 48 insertions(+), 28 deletions(-)
> 
> I wrote a very similar patch already.  I knew I should have sent it on
> Friday. :(

No problem! you can send your patch along with the MiPHY series.

Cheers
Kishon
> 
> Patch looks good, just a real minor point.
> 
>>  	phy->dev.class = phy_class;
>>  	phy->dev.parent = dev;
>> -	phy->dev.of_node = dev->of_node;
>> +	phy->dev.of_node = node?node:dev->of_node;
> 
> There should be spaces either side of the '?' and ':', or you can do
> this more succinctly by:
> 
> phy->dev.of_node = node ?: dev->of_node;
> 
> Once fixed, feel free to add my:
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
