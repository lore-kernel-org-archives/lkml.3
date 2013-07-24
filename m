Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3GXBim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:38:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45956 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750760Ab3GXBil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:38:41 -0400
Message-ID: <1374629919.10171.26.camel@joe-AO722>
Subject: Re: [PATCH 10/27] drivers/memory: don't check resource with
 devm_ioremap_resource
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Date: Tue, 23 Jul 2013 18:38:39 -0700
In-Reply-To: <51EF2D9D.8030904@wwwdotorg.org>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	 <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
	 <1374603925.3387.26.camel@joe-AO722> <51EF2D9D.8030904@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 18:27 -0700, Stephen Warren wrote:
> On 07/23/2013 11:25 AM, Joe Perches wrote:
> > On Tue, 2013-07-23 at 20:01 +0200, Wolfram Sang wrote:
> >> devm_ioremap_resource does sanity checks on the given resource. No need to
> >> duplicate this in the driver.
[]
> > This is the first and only one of the patch series I looked at.
> > 
> >> diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
> > []
> >> @@ -218,8 +218,6 @@ static int tegra20_mc_probe(struct platform_device *pdev)
> >>  		struct resource *res;
> >>  
> >>  		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> >> -		if (!res)
> >> -			return -ENODEV;
> >>  		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);
> > 
> > I'm not so sure this is appropriate.
> > 
> > devm_ioremap_resource returns ERR_PTR(-EINVAL) for
> > null resource so this changes the return.
> 
> I think the exact return value is probably pretty arbitrary here.

I think so as well, but it takes code inspection to
determine whether or not there's any code impact.

I want to make sure Wolfram has done that inspection.

> > devm_ioremap_resource also emits a noisy dev_err
> > message when resource is NULL.
> > 
> > It's a probe and before the message log would be silent
> > but now there's a new dmesg.
> 
> I think those changes are fine, at least for this driver. It's a bug if
> the required resources are missing, and having probe() actively point
> out why it's failing can only be a good thing in my book.

Again, I haven't looked at _all_ the paths for all
of these patches, I just picked one at random.

Extra dmesg output with some device probes that are
expected to fail is not good.


