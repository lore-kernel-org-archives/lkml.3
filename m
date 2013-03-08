Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038Ab3CHSkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:40:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43099 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601Ab3CHSkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:40:40 -0500
Message-ID: <513A30A6.3040806@wwwdotorg.org>
Date: Fri, 08 Mar 2013 11:40:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 3/5] ARM: DT: tegra114:add aliases and DMA requestor for
 serial controller
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com> <1362750782-15174-4-git-send-email-ldewangan@nvidia.com> <513A25E4.8040504@wwwdotorg.org> <513A281B.9010702@nvidia.com>
In-Reply-To: <513A281B.9010702@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 11:04 AM, Laxman Dewangan wrote:
> On Friday 08 March 2013 11:24 PM, Stephen Warren wrote:
>> On 03/08/2013 06:53 AM, Laxman Dewangan wrote:
>>> Add APB DMA requestor and serial aliases for serial controller.
>>> There will be two serial driver i.e. 8250 based simple serial driver
>>> and APB DMA based serial driver for higher baudrate and performace.
>>>
>>> The simple serial driver get enabled with compatible nvidia,tegra20-uart
>>> and APB DMA based driver will get enabled with compatible
>>> nvidia,tegra30-hsuart.

>>> diff --git a/arch/arm/boot/dts/tegra114.dtsi
>>> b/arch/arm/boot/dts/tegra114.dtsi
>>> +    /*
>>> +     * There are two serial driver i.e. 8250 based simple serial
>>> +     * driver and APB DMA based serial driver for higher baudrate
>>> +     * and performace. To enable the 8250 based driver, the compatible
>>> +     * is "nvidia,tegra30-uart", "nvidia,tegra20-uart" and to enable
>>> +     * the APB DMA based serial driver, the comptible is
>>> +     * "nvidia,tegra30-hsuart", "nvidia,tegra20-hsuart".
>>> +     */
>> Any references to Tegra30 there should be changed to Tegra114 I think.
> 
> Ok, there is not change on tegra30 and Tegra114, also we have not added
> the tegra114 compatible in driver file.

As I mentioned elsewhere, compatible must always include the most
specific value; nvidia,tegra114-uart in this case. If the HW is
backwards-compatible, then also include entries for the HW it's
compatible with.

Hence here, you want:

compatible = "nvidia,tegra114-uart", "nvdia,tegra20-uart";

Since the compatible value here shouldn't include any Tegra30-related
value, the comment shouldn't say that it should.

Note that when there are multiple values in the compatible property,
even if the driver doesn't know about the first value, it will still get
matched based upon the 2nd/3rd/... value, so even though the driver
doesn't explicitly know about nvidia,tegra114-uart, it will still get
instantiated, because it does support nvdia,tegra20-uart.
