Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaCZKat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:30:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52141 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbaCZKar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:30:47 -0400
Date: Wed, 26 Mar 2014 07:30:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 14/14] ARM: mvebu: register the cpuidle driver for the
 Armada XP SoCs
Message-ID: <20140326103025.GD941@arch.cereza>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
 <1395787705-31061-15-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395787705-31061-15-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Mar 25, Gregory CLEMENT wrote:
> @@ -285,4 +290,21 @@ static struct notifier_block armada_370_xp_cpu_pm_notifier = {
>  	.notifier_call = armada_370_xp_cpu_pm_notify,
>  };
>  
> +int __init armada_370_xp_cpu_pm_init(void)
> +{
> +	if (!((of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-pmsu") ||
> +				of_find_compatible_node(NULL, NULL, "marvell,armada-370-pmsu"))
> +			&& of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric")
> +			&& of_machine_is_compatible("marvell,armadaxp")))
> +		return 0;
> +

of_find_compatible_node() gets the returned node, so you should put it
after using it. How about something along this pseudo-code?

pmsu = of_find_compatible_node(pmsu);
coherency_fabric = of_find_compatible_node(coherency_fabric);

if (pmsu && coherency_fabric && of_machine_is_compatible(armadaxp)) {
	/* Do your thing ... */
}

of_node_put(pmsu);
of_node_put(coherency_fabric);

And you also gain some readability, as a side effect.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
