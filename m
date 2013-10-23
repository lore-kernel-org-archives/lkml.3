Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3JWQaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:30:17 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:55027 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3JWQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:30:14 -0400
Date: Wed, 23 Oct 2013 19:30:07 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/3] Input: twl4030-pwrbutton: simplify driver using
 devm_*
Message-ID: <20131023163007.GD24448@blackmetal.musicnaut.iki.fi>
References: <1382540482-12261-1-git-send-email-sre@debian.org>
 <1382540482-12261-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382540482-12261-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 23, 2013 at 05:01:22PM +0200, Sebastian Reichel wrote:
>  static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
>  {
>  	struct input_dev *pwr = platform_get_drvdata(pdev);
> -	int irq = platform_get_irq(pdev, 0);
>  
> -	free_irq(irq, pwr);
>  	input_unregister_device(pwr);

You need convert the driver to use devm_input_allocate_device()
first. Otherwise driver will crash the kernel here if you get interrupt
after unregistering the device.

A.
