Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3CDRb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:31:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13661 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3CDRb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:31:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 09:31:19 -0800
Message-ID: <5134DA65.1010902@nvidia.com>
Date: Mon, 4 Mar 2013 12:31:17 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4/4] power: tps65090: Add support for tps65090-charger
References: <1362006450-4979-1-git-send-email-rklein@nvidia.com> <1362006450-4979-5-git-send-email-rklein@nvidia.com> <20130303000325.GA29046@lizard.sbx05280.losalca.wayport.net>
In-Reply-To: <20130303000325.GA29046@lizard.sbx05280.losalca.wayport.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/2013 7:03 PM, Anton Vorontsov wrote:
> Hello Rhyland,
>
> Thanks for the driver! A few comments down below...
>
> On Wed, Feb 27, 2013 at 06:07:30PM -0500, Rhyland Klein wrote:
>> This patch adds support for the tps65090 charger driver.
> Would be nice to get a few more words about the hardware and the driver.
> Why it is cool, main features, what is missing (if any), what is planned.

Yah, this is really a child driver of the tps65090 mfd chip, so a lot of 
the driver coolness
is already defined there :) I'll look into the hw some and see what 
other coolness might
be possible to add around here :)

> ...
> +
> +     irq = platform_get_irq(pdev, 0);
> +     if (irq <= 0) {
> +             dev_warn(&pdev->dev, "Unable to get charger irq = %d\n", irq);
> +             return irq;
> +     }
> +
> +     ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> +             tps65090_charger_isr, 0, "tps65090-charger", charger_data);
> You should request irq after power_supply object (and charger_data) are
> fully usable. Otherwise, if irq suddenly comes midway in the registration
> process, we'll get an oops.

Yah the first time I looked at this the order struck me as kinda off, 
but I guess I got
sidetracked and forgot to go back to it. Thanks for catching this!

-rhyland

-- 
nvpublic

