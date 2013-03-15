Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3COSp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:45:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1762 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3COSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:45:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 15 Mar 2013 11:45:54 -0700
Message-ID: <51436BE6.8070207@nvidia.com>
Date: Sat, 16 Mar 2013 00:13:50 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/5] ARM: tegra:add aliases and DMA requestor for serial
 nodes of Tegra114
References: <1363204194-19487-1-git-send-email-ldewangan@nvidia.com> <1363204194-19487-4-git-send-email-ldewangan@nvidia.com> <5140DB61.3090809@wwwdotorg.org> <514367F3.6040909@wwwdotorg.org>
In-Reply-To: <514367F3.6040909@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013 11:56 PM, Stephen Warren wrote:
> On 03/13/2013 02:02 PM, Stephen Warren wrote:
>> On 03/13/2013 01:49 PM, Laxman Dewangan wrote:
>>> Add APB DMA requestor and serial aliases for serial controller.
>>> There will be two serial driver i.e. 8250 based simple serial driver
>>> and APB DMA based serial driver for higher baudrate and performace.
>>>
>>> The simple serial driver get enabled with compatible "nvidia,tegra114-uart",
>>> "nvidia,tegra20-uart" and APB DMA based driver will get enabled with
>>> compatible "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".
>>> +	/*
>>> +	 * There are two serial driver i.e. 8250 based simple serial
>>> +	 * driver and APB DMA based serial driver for higher baudrate
>>> +	 * and performace. To enable the 8250 based driver, the compatible
>>> +	 * is "nvidia,tegra114-uart", "nvidia,tegra20-uart" and to enable
>>> +	 * the APB DMA based serial driver, the comptible is
>>> +	 * "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".
>>> +	 */
>> Again, that text says you want either of:
>>
>> compatible = "nvidia,tegra114-uart",   "nvidia,tegra20-uart";
>> compatible = "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart";
>>
>> (note Tegra20-vs-Tegra30 in the second compatible value)
>>
>> Why isn't it instead:
>>
>> compatible = "nvidia,tegra114-uart",   "nvidia,tegra20-uart";
>> compatible = "nvidia,tegra114-hsuart", "nvidia,tegra20-hsuart";
>>
>> (note both second compatible values say Tegra20)
>>
>> I assume this is a typo.
>>
>> I suppose I can fix this up when I apply it to avoid a resend, assuming
>> it's wrong.
> Since I haven't seen a reply to this, when I apply this, I'm going to
> change the comment I quoted above to match the values I wrote above
> under "why isn't it instead:".

Stephen,
Sorry, I missed your comment to reply.
I mean was that compatible should be
compatible = "nvidia,tegra114-uart",   "nvidia,tegra20-uart";
compatible = "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart";

not

compatible = "nvidia,tegra114-uart",   "nvidia,tegra20-uart";
compatible = "nvidia,tegra114-hsuart", "nvidia,tegra20-hsuart";


The reason is that, tegra30 has the clock divider in the CAR register 
set and it is 15.1 which gives more precise baudrate. tegra20 does not 
have the same.
Tegra114 also have the clock divider in the CAR register.

All SoCs UART support 16.0 clock divider inside the uart controller as 
DLL/DLM.

Simple uart driver use the uart clock divider and it is fine here.

High speed uart driver uses the car register driver for better 
flexibility and better resolution.

