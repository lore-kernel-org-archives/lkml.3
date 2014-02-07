Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaBGKeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:34:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39829 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaBGKeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:34:13 -0500
Message-ID: <52F4B682.2000201@ti.com>
Date: Fri, 7 Feb 2014 12:33:38 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>
CC: Tejun Heo <tj@kernel.org>, <balbi@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <balajitk@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-9-git-send-email-rogerq@ti.com> <20130922165817.GD30946@htj.dyndns.org> <523F35E4.6050707@cogentembedded.com> <20130922215107.GD27616@mtj.dyndns.org> <523FEFC2.801@ti.com> <52403B4F.3070406@cogentembedded.com> <5240492D.6060204@ti.com>
In-Reply-To: <5240492D.6060204@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/23/2013 04:59 PM, Roger Quadros wrote:
> On 09/23/2013 03:59 PM, Sergei Shtylyov wrote:
>> Hello.
>>
>> On 23-09-2013 11:37, Roger Quadros wrote:
>>
>>>>>     Not sure why you asked -- I'm not using this driver, neither I'm
>>
>>>> Well, you have better grip of what's going on in the embedded world
>>>> than me.  I'm mostly curious whether adding dependency on PHY is okay.
>>
>>> There is no hard dependency on presence of PHY. The driver will continue
>>> as usual if devm_phy_get() fails.
>>> I hope selecting GENERIC_PHY in Kconfig is not an issue.
>>
>>    Selecting in the AHCI_PLATFORM section? It seems I have overlooked it. No, I don't think it's a good idea. The generic PHY functions seem to be stubbed when GENERIC_PHY=n.
>>
> OK I will remove the select then.

If I remove the select then build fails like so if we set CONFIG_GENERIC_PHY to 'm' and CONFIG_SATA_AHCI_PLATFORM to 'y'

drivers/built-in.o: In function `ahci_platform_enable_resources':
(.text+0x162647): undefined reference to `phy_init'
drivers/built-in.o: In function `ahci_platform_enable_resources':
(.text+0x16267c): undefined reference to `phy_power_on'
drivers/built-in.o: In function `ahci_platform_enable_resources':
(.text+0x162694): undefined reference to `phy_exit'
drivers/built-in.o: In function `ahci_platform_disable_resources':
(.text+0x1626af): undefined reference to `phy_power_off'
drivers/built-in.o: In function `ahci_platform_disable_resources':
(.text+0x1626b7): undefined reference to `phy_exit'
drivers/built-in.o: In function `ahci_platform_get_resources':
(.text+0x162768): undefined reference to `devm_phy_get'
make: *** [vmlinux] Error 1

This means we need to make CONFIG_SATA_AHCI_PLATFORM depend on CONFIG_GENERIC_PHY or
select it.

OR

Generic PHY layer must be fixed so that the API's are always built in.

What is the better option? I believe making the PHY API's always built in is the better option.

cheers,
-roger
