Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3AWK3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:29:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4742 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3AWK3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:29:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 23 Jan 2013 02:29:17 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Leela Krishna Amudala <leelakrishna.a@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>, "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
Date: Wed, 23 Jan 2013 19:29:16 +0900
Message-ID: <3208798.X7kqxH1FjQ@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.5 (Linux/3.6.11-1-ARCH; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAL1wa8d2BS3RxdsdUyCqF20ZKe46jUZcfUKitnpP9Lgb9aB5hw@mail.gmail.com>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <1358591420-7790-3-git-send-email-acourbot@nvidia.com> <CAL1wa8d2BS3RxdsdUyCqF20ZKe46jUZcfUKitnpP9Lgb9aB5hw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 18:15:30 Leela Krishna Amudala wrote:
> > +       pwm_backlight_set_subdriver_data(dev, data);
> 
> Here you are passing ventana_bl_data pointer as input and in the
> pwm_backlight_get_subdriver_data() function you are assigning the
> received driver data to backlight_device pointer. As both are two
> different structures with different structure fields in it. There can
> be a chance for a crash.

That's because the following happens later in pwm_backlight_probe():

	pb->subdriver_data = dev_get_drvdata(&pdev->dev);
	...
	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, pb,
				       &pwm_backlight_ops, &props);
	...
	platform_set_drvdata(pdev, bl);

So from then on the result of dev_get_drvdata() is indeed an instance of 
backlight_device from which we can retrieve the subdriver data. I'm not really 
proud of this. But fortunately it seems like we are going to do things 
differently.

Alex.

