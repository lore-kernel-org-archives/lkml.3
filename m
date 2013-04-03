Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360Ab3DCXmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:42:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47185 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761215Ab3DCXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:42:47 -0400
Message-ID: <515CBE71.9000401@wwwdotorg.org>
Date: Wed, 03 Apr 2013 17:42:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, arnd@arndb.de,
        akpm@linux-foundation.org, sylvester.nawrocki@gmail.com,
        rob@landley.net, netdev@vger.kernel.org, davem@davemloft.net,
        cesarb@cesarb.net, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        b-cousson@ti.com, linux@arm.linux.org.uk, eballetbo@gmail.com,
        javier@dowhile0.org, mchehab@redhat.com, santosh.shilimkar@ti.com,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/6] Generic PHY Framework
References: <1364993634-6378-1-git-send-email-kishon@ti.com>
In-Reply-To: <1364993634-6378-1-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 06:53 AM, Kishon Vijay Abraham I wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle. To obtain a reference to the PHY
> without using phandle, the platform specfic intialization code (say from board
> file) should have already called phy_bind with the binding information. The
> binding information consists of phy's device name, phy user device name and an
> index. The index is used when the same phy user binds to mulitple phys.
...
> Changes from v4:
> * removed of_phy_get_with_args/devm_of_phy_get_with_args. Now the *phy providers*
>   should use their custom implementation of of_xlate or use of_phy_xlate to get
>   *phy instance* from *phy providers*.
> * Added of_phy_xlate to be used by *phy providers* if it provides only one PHY.
> * changed phy_core from having subsys_initcall to module_init.

s/of_phy_xlate/of_phy_simple_xlate/ ? That would hightlight the fact
it's just /an/ implementation for the simple case, not /the/
implementation for all cases. It'd be consistent with e.g. drivers/gpio,
which has of_gpio_simple_xlate().
