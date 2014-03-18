Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaCRQHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:07:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42801 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbaCRQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:07:08 -0400
Date: Tue, 18 Mar 2014 16:07:01 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] regulator: arizona-ldo1: Add processing of
	init_data from device tree
Message-ID: <20140318160701.GD1665@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1395139757-6907-5-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140318111542.GK11706@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318111542.GK11706@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:15:42AM +0000, Mark Brown wrote:
> On Tue, Mar 18, 2014 at 10:49:13AM +0000, Charles Keepax wrote:
> 
> > +  - wlf,ldo1 : Initial data for the LDO1 regulator, as covered in
> > +    Documentation/devicetree/bindings/regulator/regulator.txt
> 
> We don't normally prefix the names of the regulator data with a vendor.
> 
> > +	np_init = of_get_child_by_name(arizona->dev->of_node, "wlf,ldo1");
> 
> You're missing an of_node_put() for this and if you're going to use
> hungarian notation please use a convention other people use.  Calling
> things _node seems more common.

The DCVDD one needs an of_node_put but I am not sure this one
does. As it will be copied into the regulator device of_node by
the regulator core so wont of_node_put be called when the device
is destroyed? Admittedly I haven't checked that but seems
sensible that the device structure would put its of_node when it
closes down.

Thanks,
Charles

