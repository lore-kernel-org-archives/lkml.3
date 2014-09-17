Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbaIQWG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:06:58 -0400
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:39215 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756175AbaIQWG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:06:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:4321:5007:6119:7514:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tin53_595a473d17f29
X-Filterd-Recvd-Size: 3860
Message-ID: <1410991612.4290.10.camel@joe-AO725>
Subject: Re: [PATCH 1/9] eeepc-laptop: clean up coding style
From: Joe Perches <joe@perches.com>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 15:06:52 -0700
In-Reply-To: <1410990447-3210-2-git-send-email-fransklaver@gmail.com>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
	 <1410990447-3210-2-git-send-email-fransklaver@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 23:47 +0200, Frans Klaver wrote:
> Correct indentation and brace usage to comply with
> Documentation/CodingStyle.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 3095d38..653999e 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -544,7 +544,7 @@ static int eeepc_led_init(struct eeepc_laptop *eeepc)
>  	eeepc->tpd_led.name = "eeepc::touchpad";
>  	eeepc->tpd_led.brightness_set = tpd_led_set;
>  	if (get_acpi(eeepc, CM_ASL_TPD) >= 0) /* if method is available */
> -	  eeepc->tpd_led.brightness_get = tpd_led_get;
> +		eeepc->tpd_led.brightness_get = tpd_led_get;
>  	eeepc->tpd_led.max_brightness = 1;
>  
>  	rv = led_classdev_register(&eeepc->platform_device->dev,
> @@ -692,8 +692,9 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
>  		 * changed during setup.
>  		 */
>  		eeepc_rfkill_hotplug(eeepc, handle);
> -	} else
> +	} else {
>  		return -ENODEV;
> +	}
>  
>  	return 0;
>  }

This sort of code:

	if (foo) {
		[ do_something ]
	} else
		return -ERRVAL;

is generally better rewritten as:

	if (!foo)
		return -ERRVAL;

	[ do_something ]

This gives immediacy to the error handler and
as well reduces unnecessary indentation.

So instead of:

static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
					  char *node)
{
	acpi_status status;
	acpi_handle handle;

	status = acpi_get_handle(NULL, node, &handle);

	if (ACPI_SUCCESS(status)) {
		status = acpi_install_notify_handler(handle,
						     ACPI_SYSTEM_NOTIFY,
						     eeepc_rfkill_notify,
						     eeepc);
		if (ACPI_FAILURE(status))
			pr_warn("Failed to register notify on %s\n", node);

		/*
		 * Refresh pci hotplug in case the rfkill state was
		 * changed during setup.
		 */
		eeepc_rfkill_hotplug(eeepc, handle);
	} else
		return -ENODEV;

	return 0;
}

try something like:

static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
					  char *node)
{
	acpi_handle handle;
	acpi_status status = acpi_get_handle(NULL, node, &handle);

	if (!ACPI_SUCCESS(status))
		return -ENODEV;

	status = acpi_install_notify_handler(handle,
					     ACPI_SYSTEM_NOTIFY,
					     eeepc_rfkill_notify,
					     eeepc);
	if (ACPI_FAILURE(status))
		pr_warn("Failed to register notify on %s\n", node);

	/*
	 * Refresh pci hotplug in case the rfkill state was
	 * changed during setup.
	 */
	eeepc_rfkill_hotplug(eeepc, handle);

	return 0;
}


