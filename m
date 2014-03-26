Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaCZMBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:01:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52702 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754083AbaCZMBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:01:49 -0400
Message-ID: <5332C1A8.8040307@free-electrons.com>
Date: Wed, 26 Mar 2014 13:01:44 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] ARM: mvebu: Extend the pmsu registers
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com> <1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com> <5332C267.3080908@gmail.com>
In-Reply-To: <5332C267.3080908@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2014 13:04, Sebastian Hesselbarth wrote:
> On 03/25/2014 11:48 PM, Gregory CLEMENT wrote:
>> The initial binding for PMSU were wrong. It didn't take into account
>> all the registers from the PMSU and moreover it referred to registers
>> which are not part of PMSU.
>>
>> The Power Management Unit Service block also controls the Coherency
>> Fabric subsystem. These registers are needed for the CPU idle
>> implementation for the Armada 370/XP, it allows to enter a deep CPU
>> idle state where the Coherency Fabric and the L2 cache are powered
>> down.
>>
>> This commit add support for a new compatible for the PMSU node
>> including the block related to the coherency fabric. It also keeps
>> compatibility with the old binding
>>
>> This patch also adds warnings if one of the base registers set can't
>> be ioremapped.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>   arch/arm/mach-mvebu/pmsu.c | 47 +++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 42 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
>> index d71ef53107c4..865bcb651e01 100644
>> --- a/arch/arm/mach-mvebu/pmsu.c
>> +++ b/arch/arm/mach-mvebu/pmsu.c
> [...]
>> +static void __init armada_370_xp_pmsu_legacy_init(struct device_node *np)
>> +{
>> +	u32 addr;
>> +	pr_warn("*** Warning ***  Using an old binding which will be deprecated\n");
>> +	/* We just need the adress, we already know the size */
>> +	addr = be32_to_cpu(*of_get_address(np, 0, NULL, NULL));
>> +	addr -= PMSU_BASE_OFFSET;
>> +	pmsu_mp_base = ioremap(addr, PMSU_REG_SIZE);
>> +	of_node_put(np);
> 
> When messing with OF passed resources, I suggest to use
> of_address_to_resource() and work on the struct resource
> instead. The be32_to_cpu pointing to an immediate just looks
> strange.

Actually it was taken from of_address_to_resource()! As I didn't need
the size I have just took the usefull part for my need.

> 
> Sebastian
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
