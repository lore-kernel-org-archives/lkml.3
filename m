Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbaE3QZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:25:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48328 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaE3QZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:25:19 -0400
Message-ID: <5388AF2D.4060909@wwwdotorg.org>
Date: Fri, 30 May 2014 10:17:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] efuse driver for Tegra
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com> <53878407.3050409@wwwdotorg.org> <20140530082356.GP5961@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140530082356.GP5961@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 02:23 AM, Peter De Schrijver wrote:
> On Thu, May 29, 2014 at 09:01:27PM +0200, Stephen Warren wrote:
>> On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
>>> This driver allows userspace to read the raw efuse data. Its userspace
>>> interface is modelled after the sunxi_sid driver which provides similar
>>> functionality for some Allwinner SoCs. It has been tested on
>>> Tegra20 (ventana), Tegra30 (beaverboard), Tegra114 (dalmore) and
>>> Tegra124 (jetson TK1).
>>
>>> Changes since v4:
>>>
>>> * Provide fallback to hardcoded 0x70000800 in case the apbmisc DT node is
>>>   missing. This is exactly what the current code does and prevents a system
>>>   crash in that case due to an invalid memory access by tegra_read_chipid()
>>
>> Wouldn't it be better to simply return an error?
> 
> This would mean you can't boot a system with these patches applied unless you
> also update the device tree. The system would crash during boot because CCF
> relies on tegra_read_chipid() as an APB barrier. Also tegra_boot_secondary()
> relies on the chipid to select the correct method for booting secondary cores.

Is this series really backwards-compatible anyway? tegra_init_fuse()
contains a whole bunch of places where resources are pulled out of DT,
and only one of those has a fallback to use APBMISC_BASE if the DT entry
isn't present.
