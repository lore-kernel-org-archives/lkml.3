Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3ISMBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:01:07 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:45775 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3ISMBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:01:04 -0400
Date: Thu, 19 Sep 2013 13:00:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
Message-ID: <20130919120051.GG22389@lee--X1>
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
 <20130919083050.GH16984@lee--X1>
 <20130919115501.GM21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130919115501.GM21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Mark Brown wrote:

> On Thu, Sep 19, 2013 at 09:30:50AM +0100, Lee Jones wrote:
> 
> > I'm not entirely sure this is what Mark was saying. I think he was
> > complaining about the existence of the sub-nodes rather than how the
> > MFD Core assigns their of_node. My take is that the chip is really a
> > single device which provides different bits of functionality. To break
> > that functionality up and disperse the drivers into various subsystems
> > is a Linuxisum. By providing each functional block with its own node
> > you're describing how we do things in Linux, rather than specifying a
> > single node for the AS3722 which would probably be the norm.
> 
> Yes, that's exactly what I was thinking of.
> 
> > Do the sub-nodes have their own properties? If so, it would be worth
> > breaking them up as other OSes could reuse the specifics. If they do,
> > then you need so put them in the binding. If they don't, then you do
> > not require sub-nodes. The MFD core will ensure the sub-devices are
> > probed and there is no requirement for the of_node to be assigned.
> 
> You do see some reusable IP blocks (like the regualtors on the wm831x
> PMICs for example, they're repeated blocks) which can be reused but
> generally they have a register base as part of the binding.  Personally
> if it's just a property or two I'd probably just put them on the root
> node for the device.

Agreed. Besides, there doesn't seem to be *any* sub-device properties
defined in the binding document. So what are you trying to achieve
with the child nodes?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
