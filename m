Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3JWRZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:25:34 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:51051 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3JWRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:25:32 -0400
Date: Wed, 23 Oct 2013 20:25:24 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv3 3/3] Input: twl4030-pwrbutton: simplify driver using
 devm_*
Message-ID: <20131023172524.GE24448@blackmetal.musicnaut.iki.fi>
References: <1382546835-20212-1-git-send-email-sre@debian.org>
 <1382546835-20212-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382546835-20212-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 23, 2013 at 06:47:15PM +0200, Sebastian Reichel wrote:
>  static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
>  {
>  	struct input_dev *pwr = platform_get_drvdata(pdev);
> -	int irq = platform_get_irq(pdev, 0);
>  
> -	free_irq(irq, pwr);
>  	input_unregister_device(pwr);

The same bug still exists. You don't need to unregister manually any more,
this whole function can be just reduced to "return 0;".

A.
