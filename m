Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBNJGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:06:15 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39217 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBNJGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:06:10 -0500
Date: Fri, 14 Feb 2014 10:06:01 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: stefan.sorensen@spectralink.com, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/3] dp83640: Get pin and master/slave configuration
 from DT
Message-ID: <20140214090601.GA3906@netboy>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
 <20140213.173957.2126489785330496380.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213.173957.2126489785330496380.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 05:39:57PM -0500, David Miller wrote:

> You'll have to code this in a way such that people who currently specify
> this parameter keep working.

So, do module parameters count as user land ABI?

[ In any case, for this module, there must be a way to retain the
  parameters and still offer DT, and letting DT have precedence. ]

People want to be able to configure the auxiliary functions on the
pins of their PTP devices. My preference for supporting this is:

1. additional ioctl on the PTP character device
2. ethtool ioctl
3. DT and/or ACPI

The first option seems best because that is how you activate the
auxiliary functions. I am working on something in this direction.

Can't we just drop the DT idea altogther?

> If you don't like it, be angry at whoever added this module parameter
> in the first place, not me.  Module parameters are 99 times out of 100
> not the right way to configure something, really.

Yeah, I am the one, be angry with me.

Sorry,
Richard
