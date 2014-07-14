Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaGNNhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:37:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbaGNNhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:37:16 -0400
Message-ID: <53C3DCF0.3030001@redhat.com>
Date: Mon, 14 Jul 2014 15:36:48 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
CC: swarren@wwwdotorg.org, thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com> <1403101406-15439-7-git-send-email-mperttunen@nvidia.com> <20140708132216.GA4979@htj.dyndns.org>
In-Reply-To: <20140708132216.GA4979@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/08/2014 03:22 PM, Tejun Heo wrote:
> (cc'ing Hans)
> 
> Hans, can you please review this patch?

Done.

Mikko, it looks like you are doing a lot of stuff
the DIY way. I can see there are good reasons for
that though.

Still it would be nice if you could use a little bit
more of the helper functions provided by libahci_platform.c

Specifically I think it would be better if you used
ahci_platform_get_resources, that would remove a lot of
duplicate code from the new driver.

To be specific I would like to suggest that you
raise AHCI_MAX_CLKS to 4, and then specify an order
in which the clks must be listed in the devicetree
binding. Then you can put that order in an enum
and use hpriv->clks[CLK_FOO] in your driver, where
CLK_FOO comes from the enum.

This way you should be able to use ahci_platform_get_resources
and drop doing the iomap of the base registers, all the
clk_gets and the phy_get yourself.

You could then also use ahci_platform_disable_clks() in
tegra_ahci_power_off

Regards,

Hans
