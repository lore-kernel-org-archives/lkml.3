Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaHTUQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:16:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35790 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaHTUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:16:29 -0400
Message-ID: <53F50231.5010605@wwwdotorg.org>
Date: Wed, 20 Aug 2014 14:16:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com
Subject: Re: [PATCH v2 1/5] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> Hardware-triggered thermal reset requires configuring the I2C
> reset procedure. This configuration is read from the device tree,
> so document the relevant properties in the binding documentation.

> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt

> +Hardware-triggered thermal reset:
> +On Tegra30, Tegra114 and Tegra124, if the 'i2c-thermtrip' subnode exists,
> +hardware-triggered thermal reset will be enabled.

"will be enabled" sounds like SW behaviour, whereas DT is suppose to 
describe HW, and leave SW to define its own behaviour. I would suggest:

Optional sub-nodes:
i2c-thermtrip: Describes how to power off the system in the event of a
   thermal emergency.

> +Required properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):

Simpler might be:

Required properties for i2c-thermtrip node:

> +- nvidia,pmu : Phandle to power management unit / PMIC handling poweroff
> +- nvidia,reg-addr : I2C register address to write poweroff command to
> +- nvidia,reg-data : Poweroff command to write to PMU

Why are both the PMU/PMIC phandle and the register address/data 
required? I thought the purpose of having the phandle was to allow the 
register address and data to be queried from the PMU/PMIC driver.

To me, it seems much simpler to get rid of the phandle and just 
hard-code the I2C bus number, address, and data into this node, rather 
than having to go query it from the PMU/PMIC driver, then find the I2C 
controller, then query it for its ID (and hope that all HW modules that 
talk to I2C controllers directly use the same numbering scheme...)
