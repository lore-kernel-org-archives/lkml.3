Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaCaKap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:30:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55037 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaCaKam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:30:42 -0400
Date: Mon, 31 Mar 2014 11:30:20 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Harini Katakam <harinik@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, michals@xilinx.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: Add Cadence WDT driver
Message-ID: <20140331113020.03be6894@alan.etchedpixels.co.uk>
In-Reply-To: <1396002720-7105-1-git-send-email-harinik@xilinx.com>
References: <1396002720-7105-1-git-send-email-harinik@xilinx.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	wdt->cdns_wdt_notifier.notifier_call = &cdns_wdt_notify_sys;
> +	/* Register the reboot notifier */
> +	ret = register_reboot_notifier(&wdt->cdns_wdt_notifier);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "cannot register reboot notifier err=%d)\n",
> +			ret);
> +		return ret;

Your ordering is wrong. If the box reboots between here and the spin lock
in it further down it'll crash in your notifier.

As

> +	spin_lock_init(&wdt->io_lock);

is needed before the code your notifier calls will work.

> +	dev_info(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds%s\n",
> +		 wdt->regs, cdns_wdt_device->timeout,
> +		 nowayout ? ", nowayout" : "");

dev_dbg

if every driver felt the need to announce itself on boot you'd have pages
and pages of junk.

Alan
