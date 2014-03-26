Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaCZKii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:38:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52265 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751616AbaCZKig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:38:36 -0400
Message-ID: <5332AE28.3040403@free-electrons.com>
Date: Wed, 26 Mar 2014 11:38:32 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v5 14/14] ARM: mvebu: register the cpuidle driver for
 the Armada XP SoCs
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com> <1395787705-31061-15-git-send-email-gregory.clement@free-electrons.com> <20140326113159.48c3c405@skate>
In-Reply-To: <20140326113159.48c3c405@skate>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2014 11:31, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Tue, 25 Mar 2014 23:48:25 +0100, Gregory CLEMENT wrote:
> 
>> +int __init armada_370_xp_cpu_pm_init(void)
>> +{
>> +	if (!((of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-pmsu") ||
>> +				of_find_compatible_node(NULL, NULL, "marvell,armada-370-pmsu"))
>> +			&& of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric")
>> +			&& of_machine_is_compatible("marvell,armadaxp")))
>> +		return 0;
> 
> Instead of this big single condition, maybe it could be split in a
> nicer way:
> 
> 	/*
> 	 * Check that all the requirements are available to enable
> 	 * cpuidle. So far, it is only supported on Armada XP, cpuidle
> 	 * needs the coherency fabric and the PMSU enabled
>          */
> 
> 	if (!of_machine_is_compatible("marvell,armadaxp"))
> 		return 0;
> 
> 	np = of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric");
> 	if (!np)
> 		return 0;
> 	of_node_put(np);
> 
> 	np = of_find_matching_node(NULL, of_pmsu_table);

Oh yes the pmsu table! I was concerned by this big condition, yesterday but
I didn't find a proper solution due to the test to the 2 comaptible string:
I forgot the pmsu table.

I will do this change (I mean using the pmsu table but also splitting the
condition in small chunk).

Thanks,

Gregory


> 	if (!np)
> 		return 0;
> 	of_node_put(np);
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
