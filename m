Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839Ab3GWSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:25:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47950 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933204Ab3GWSZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:25:26 -0400
Message-ID: <1374603925.3387.26.camel@joe-AO722>
Subject: Re: [PATCH 10/27] drivers/memory: don't check resource with
 devm_ioremap_resource
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org
Date: Tue, 23 Jul 2013 11:25:25 -0700
In-Reply-To: <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	 <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 20:01 +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Hi Wolfram:

This is the first and only one of the patch series I looked at.

> diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
[]
> @@ -218,8 +218,6 @@ static int tegra20_mc_probe(struct platform_device *pdev)
>  		struct resource *res;
>  
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> -		if (!res)
> -			return -ENODEV;
>  		mc->regs[i] = devm_ioremap_resource(&pdev->dev, res);

I'm not so sure this is appropriate.

devm_ioremap_resource returns ERR_PTR(-EINVAL) for
null resource so this changes the return.

devm_ioremap_resource also emits a noisy dev_err
message when resource is NULL.

It's a probe and before the message log would be silent
but now there's a new dmesg.

Perhaps that should be mentioned in the changelog here
and elsewhere in the series.


