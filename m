Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3LCLVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:21:18 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38108 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3LCLVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:21:15 -0500
Date: Tue, 3 Dec 2013 11:21:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <a0393675@ti.com>
Cc: Keerthy <j-keerthy@ti.com>, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, sameo@linux.intel.com,
        grant.likely@linaro.org, lgirdwood@gmail.com, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/4] MFD: TPS65218: Add driver for the TPS65218 PMIC
Message-ID: <20131203112107.GP11828@lee--X1>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
 <1386053006-6480-3-git-send-email-j-keerthy@ti.com>
 <20131203092410.GD11828@lee--X1>
 <529DAD2B.4040909@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529DAD2B.4040909@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+	ret = of_platform_populate(client->dev.of_node, NULL, NULL,
> >>+				   &client->dev);
> >What are you trying to do here?
> >
> >Register each regulator as a platform device?
> 
> Yeah. The probe will be called for every regulator separately.

So there are two schools of thought on this. One is that if you want
to do it that way you should use the MFD framework to do this for you.
There is no need to recreate functionality that already exists. The
other is that you shouldn't be doing this at all with regulators. Mark
likes the idea of having a single regulator controller node which
contains all of these individual regulator sub-nodes and you initiate
a single call to for_each_child_of_node() within the driver in order
to register them all.

<snip>

> >This has a different structure to of_tps65218_match_table, please
> >ensure they're the same. I prefer spaces after '{' and before '}'.
> 
> Ok. I will add a space after '{' and before '}'. Sorry I did not
> follow tps65218_id_table being different than of_tps65218_match_table.
> 
> One is of the type of_device_id and the other i2c_device_id.

Shouldn't matter, it's just a formatting thing.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
