Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3FXLf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:35:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42572 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab3FXLfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:35:24 -0400
Message-ID: <51C82EC5.8070102@ti.com>
Date: Mon, 24 Jun 2013 17:04:29 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Joel A Fernandes <agnel.joel@gmail.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Koen Kooi <koen@beagleboard.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Joel A Fernandes <joelagnel@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <201306211632.12577.arnd@arndb.de> <CAD=GYpbhBAaSkMtcJaPtVpWar7AcW37QpAk3A0qgwX6G5PDoZg@mail.gmail.com> <201306212044.26677.arnd@arndb.de> <CAD=GYpY4koXd9f6_ijQfDHsiULD4d53cdu=9X421WXSAit_YQg@mail.gmail.com> <51C82C3C.8040506@ti.com>
In-Reply-To: <51C82C3C.8040506@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/2013 4:53 PM, Sekhar Nori wrote:
> On 6/22/2013 3:23 AM, Joel A Fernandes wrote:
>> Hi Arnd,
>>
>> On Fri, Jun 21, 2013 at 1:44 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Friday 21 June 2013, Joel A Fernandes wrote:
>>>> I think we are talking about different things, I agree the 'select
>>>> DMADEVICES' can be dropped but lets please keep the default y option
>>>> (not adding new select statements, just saying that if someone select
>>>> DMADEVICES in menuconfig and if they're ARCH_OMAP=1 , then default to
>>>> EDMA). This will simply allow people to have a default. Thanks.
>>>
>>> Yes, that's ok.
>>
>> Ok, thanks. I will follow up with a patch in my next submissions that builds it.
>>
>> Perhaps a:
>> default y if 'ARCH_OMAP2PLUS'
>>
>> and leave the existing as it is...
>> default n if  'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2'
>>
>> would make most sense to me. Basically EDMA is seen on current and all
>> new OMAP2PLUS.
> 
> OMAP2PLUS devices like OMAP3/4 do not have EDMA so this is not really true.

More accurately, there is EDMA hardware on these devices, but its usage
is limited to DSP. ARM uses SDMA instead.

Thanks,
Sekhar
