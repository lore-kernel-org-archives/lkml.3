Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaCFKAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:00:20 -0500
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:57441 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829AbaCFKAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:00:16 -0500
Message-ID: <5318472A.5060700@codethink.co.uk>
Date: Thu, 06 Mar 2014 10:00:10 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@lists.codethink.co.uk,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Lorenzon Pieralisi <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-kernel] [PATCH] ARM: kernel: respect device tree status
 of cpu nodes
References: <1393240960-31846-1-git-send-email-j@bitron.ch> <53178A03.3090004@codeaurora.org>
In-Reply-To: <53178A03.3090004@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 20:33, Stephen Boyd wrote:
> +Lorenzo
>
> On 02/24/14 03:22, Jürg Billeter wrote:
>> Skip 'disabled' cpu nodes when building the cpu logical map. This avoids
>> booting cpus that have been disabled in the device tree.
>>
>> Signed-off-by: Jürg Billeter <j@bitron.ch>
>> Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   arch/arm/kernel/devtree.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
>> index 739c3df..9aed299 100644
>> --- a/arch/arm/kernel/devtree.c
>> +++ b/arch/arm/kernel/devtree.c
>> @@ -95,6 +95,10 @@ void __init arm_dt_init_cpu_maps(void)
>>   		if (of_node_cmp(cpu->type, "cpu"))
>>   			continue;
>>
>> +		/* Check if CPU is enabled */
>> +		if (!of_device_is_available(cpu))
>> +			continue;
>> +
>>   		pr_debug(" * %s...\n", cpu->full_name);
>>   		/*
>>   		 * A device tree containing CPU nodes with missing "reg"
>
> This doesn't follow the ePAPR spec. According to ePAPR status="disabled"
> in a cpu node means "the cpu is in a quiescent state" and one can enable
> it by using the "enable-method". At the least, we should document this
> in bindings/arm/cpus.txt if we can all agree that we want this
> definition of disabled.

My view was that disabled should be the same as for the device case
as it makes sense that way.

We have a position where we want to use the .dtsi files but not all
cpus are available to the Linux. If we cannot use disabled then we
need some other method to say this cpu node is not available, so
please do not try and bring it online (saves boot time waiting for
CPU nodes that cannot online)

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
