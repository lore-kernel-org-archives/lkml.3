Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3IXNzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:55:32 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57527 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3IXNz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:55:28 -0400
Date: Tue, 24 Sep 2013 14:55:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Mark Brown <broonie@kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
Message-ID: <20130924135522.GA16407@lee--X1>
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
 <20130919083050.GH16984@lee--X1>
 <20130919115501.GM21013@sirena.org.uk>
 <20130919120051.GG22389@lee--X1>
 <523AEE07.9090405@nvidia.com>
 <20130919122240.GI22389@lee--X1>
 <5240A88D.8030309@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5240A88D.8030309@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> And regulator driver should get the regulator node by their
> >> pdev->dev.of_node.
> >> Currently, in most of driver, we are having the code on regulator
> >> driver to get "regulators" node from parent node which I want to
> >> avoid.
> > 
> > Ah, I see. Yes, I believe the regulators should have their own node,
> 
> The use of a "regulators" node to keep all the regulator configuration
> in one place seems fine...
> 
> > complete with a compatible string.
> 
> ... but I see not reason why that node has to have a separate compatible
> property, or /has/ to have a separate driver.
> 
> I think having a compatible value in this node would only be required if
> the HW block that implements those registers is actually expected to be
> shared between n different chips, and hence it's likely that you'd get
> re-use out of a separate binding, driver, etc.
> 
> It's perfectly reasonable for the regulator MFD driver to know that the
> binding for the top-level PMIC node has a regulators child node, and go
> find it by name, and read whatever properties/nodes it needs directly
> out of it. Writing code that way in no ways implies a need for a
> compatible value.

Sounds fine.

> > To have each regulator listed
> > separately in the parent node seems a little messy. Just out of
> > interest, how many regulators are we talking about here?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
