Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3E0Gpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:45:46 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.140]:24472 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499Ab3E0Gpp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:45:45 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-10.tower-178.messagelabs.com!1369637141!28045576!2
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 27 May 2013 08:45:42 +0200
From: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH v3] watchdog: New watchdog driver for MEN A21 watchdogs
Thread-Topic: [PATCH v3] watchdog: New watchdog driver for MEN A21 watchdogs
Thread-Index: AQHOUZypETFHwwre50CoMr2e5t9vq5kXd2KAgAEwMCA=
Date: Mon, 27 May 2013 06:45:39 +0000
Message-ID: <42A09AAC7DAAF64ABE4E4C1AD5F5E295094C82A0@MEN-EX1.intra.men.de>
References: <1368560034.24692.4.camel@joe-AO722>
 <1368643810-2789-1-git-send-email-johannes.thumshirn@men.de>
 <20130526143403.GB7603@spo001.leaseweb.com>
In-Reply-To: <20130526143403.GB7603@spo001.leaseweb.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.6.58]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 May 2013 06:45:41.0017 (UTC) FILETIME=[CDDBF090:01CE5AA5]
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
> +	.notifier_call = a21_wdt_notify_sys, };
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


Hi Wim,

Of cause I'll do, but unfortunately I probably won't be able to do it today, mind if you get the patch tomorrow?

Regards,
Johannes.
