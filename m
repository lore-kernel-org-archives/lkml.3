Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab3EZOeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:34:07 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48060 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215Ab3EZOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:34:05 -0400
Date: Sun, 26 May 2013 16:34:03 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: johannes.thumshirn@men.de
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130526143403.GB7603@spo001.leaseweb.com>
References: <1368560034.24692.4.camel@joe-AO722> <1368643810-2789-1-git-send-email-johannes.thumshirn@men.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368643810-2789-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> +static int a21_wdt_notify_sys(struct notifier_block *notify, unsigned long code,
> +			void *unused)
> +{
> +	if (code == SYS_DOWN || code == SYS_HALT)
> +		gpio_set_value(GPIO_WD_ENAB, 0);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block a21_wdt_notifier = {
> +	.notifier_call = a21_wdt_notify_sys,
> +};
...
> +	ret = register_reboot_notifier(&a21_wdt_notifier);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot register reboot notifier\n");
> +		goto err_register_notif;
> +	unregister_reboot_notifier(&a21_wdt_notifier);
...
> +	unregister_reboot_notifier(&a21_wdt_notifier);
...
> +static struct platform_driver a21_wdt_driver = {
> +	.probe = a21_wdt_probe,
> +	.remove = a21_wdt_remove,
> +	.driver = {
> +		.name = "a21-watchdog",
> +		.of_match_table = a21_wdt_ids,
> +	},
> +};

I prefer to have the reboot_notifier is being replaced by a platform .shutdown function.
Can you also split the sysfs stuff as a second patch so that I can review that seperately?

Kind regards,
Wim.

