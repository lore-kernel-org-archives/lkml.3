Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaBMWkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:40:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50901 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaBMWkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:40:00 -0500
Date: Thu, 13 Feb 2014 17:39:57 -0500 (EST)
Message-Id: <20140213.173957.2126489785330496380.davem@davemloft.net>
To: stefan.sorensen@spectralink.com
Cc: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/3] dp83640: Get pin and master/slave configuration
 from DT
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 14:40:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Sørensen <stefan.sorensen@spectralink.com>
Date: Thu, 13 Feb 2014 15:35:22 +0100

> This patch series add DT configuration to the DP83640 PHY driver and makes
> the configuration of periodic output pins dynamic.
> 
> Changes since v2:
>  - Add patch to properly configure perout triggers 0+1
>  - Keep extts and perout numbers separate
>  - Shorten pr_err lines
> 
> Changes since v1:
>  - Add bindings documentation
>  - Keep module parameters
>  - Rename gpio->pin
>  - Split patch into DT part and dynamic periodic output support
> 
> Stefan Sørensen (3):
>   net:phy:dp83640: Program pulsewidth2 values of perout triggers 0 and 1
>   net:phy:dp83640: Support a configurable number of periodic outputs
>   net:phy:dp83640: Get pin and master/slave configuration from DT

I'm not applying this.

This is a great example of why I hate module parameters.

Whoever added these module parameters in the first place took the easy
road and didn't have to think about whether this was a good way or not
to specify these parameters.  Do you really think we can, like magic,
just remove this module parameter without having to think about the
consequences of that action at all?

The entities currently specifying this parameter, do they just lose?

Sorry, that's unacceptable.

You'll have to code this in a way such that people who currently specify
this parameter keep working.

If you don't like it, be angry at whoever added this module parameter
in the first place, not me.  Module parameters are 99 times out of 100
not the right way to configure something, really.

Thanks.
