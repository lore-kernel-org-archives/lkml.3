Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaHUPli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:41:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54073 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaHUPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:41:36 -0400
Message-ID: <53F61345.2080803@wwwdotorg.org>
Date: Thu, 21 Aug 2014 09:41:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com
Subject: Re: [PATCH v2 2/5] of: Add nvidia,controller-id property to Tegra
 I2C bindings
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-3-git-send-email-mperttunen@nvidia.com> <53F502D7.9030403@wwwdotorg.org> <20140821070511.GF4486@ulmo>
In-Reply-To: <20140821070511.GF4486@ulmo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 01:05 AM, Thierry Reding wrote:
> On Wed, Aug 20, 2014 at 02:19:35PM -0600, Stephen Warren wrote:
>> On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
>>> Sometimes, hardware blocks want to issue requests to devices
>>> connected to I2C buses by itself. In such case, the bus the
>>> target device resides on must be configured into a register.
>>> For this purpose, each I2C controller has a defined ID known
>>> by the hardware. Add a property for these IDs to the device tree
>>> bindings, so that drivers can know what ID to write to a hardware
>>> register when configuring a block that sends I2C messages autonomously.
>>
>>> diff --git a/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt b/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt
>>
>>> +Optional properties:
>>> +- nvidia,controller-id: ID of controller when referred to in
>>> +                        hardware registers.
>>
>> I'd prefer to put this information into the thermal trip node, since this
>> represents what ID the PMC uses to communicate with the I2C controller, and
>> there's no absolute guarantee that multiple clients that communicate
>> directly with an I2C controller would use the same numbering scheme.
>>
>> If that doesn't work, can be at least name this nvidia,pmc-controller-id or
>> nvidia,id-in-pmc so that if there are different numbering schemes, there's a
>> clear path to represent this in different properties without conflicting
>> names?
>
> This is the ID of the controller used internally by the documentation.
> And as far as I can tell every aspect of the documentation refers to the
> controllers by the same ID (clocks, interrupts, ...). The PMC uses this
> same numbering scheme. That makes the ID about as canonical as it gets,
> so the extra prefix isn't warranted in my opinion.
>
> I'd argue that if ever there was a case where something was referring to
> the controller using a different ID then that should be considered the
> oddball and get special treatment.

This is certainly true in practice in current SoCs, but in general, 
there's no reason why every HW module that talks to I2C HW modules needs 
to be hooked up to all of them in the same order, especially if SoCs 
start getting put together by mixing/matching components from all kinds 
of vendors etc.

Still, since they are today, I suppose that binding is fine; we can 
always modify the binding for any new SoC (and associated compatible 
value) in the future if the current rule ever gets broken. The code will 
be a little annoying though.
