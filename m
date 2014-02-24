Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBXP5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:57:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57267 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaBXP5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:57:32 -0500
Message-ID: <530B6BC3.6070306@ti.com>
Date: Mon, 24 Feb 2014 09:56:51 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Sebastian Reichel <sre@debian.org>
CC: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        =?UTF-8?B?0JjQstCw0Lk=?= =?UTF-8?B?0LvQviDQlNC40LzQuNGC0YDQvtCy?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv1 5/6] HSI: Introduce OMAP SSI driver
References: <1393199401-27197-1-git-send-email-sre@debian.org> <1393199401-27197-6-git-send-email-sre@debian.org> <20140224155132.GK28555@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140224155132.GK28555@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:51 AM, Mark Rutland wrote:
> On Sun, Feb 23, 2014 at 11:50:00PM +0000, Sebastian Reichel wrote:

[...]
>> +static int omap_ssi_port_runtime_suspend(struct device *dev)
>> +{
>> +       struct hsi_port *port = dev_get_drvdata(dev);
>> +       struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
>> +       struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
>> +       struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
>> +
>> +       dev_dbg(dev, "port runtime suspend!\n");
>> +
>> +       ssi_set_port_mode(omap_port, SSI_MODE_SLEEP);
>> +       if (omap_ssi->get_loss)
>> +               omap_port->loss_count =
>> +                               (*omap_ssi->get_loss)(ssi->device.parent);
> 
> You don't need to do (*struct->func)(args) when invoking a function
> pointer. You can jsut have struct->func(args) as we do elsewhere. This
> can be:
> 
>   omap_ssi->get_loss(ssi->device.parent)
> 
> This should be fixed up in the other sites too.

in fact, we should stop expecting that service and drivers should
manage their own context_loss detection
Examples:
MMC:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0a82e06e6183a252608df48cc4793b83e2d73dfd

DSS: http://marc.info/?l=linux-omap&m=139272358619064&w=2


-- 
Regards,
Nishanth Menon
