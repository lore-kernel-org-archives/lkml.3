Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaL0USG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:18:06 -0500
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:33995 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751829AbaL0USE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:18:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:4321:5007:6261:6742:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: art23_45e2ebb147c49
X-Filterd-Recvd-Size: 2280
Message-ID: <1419711478.20894.5.camel@perches.com>
Subject: Re: [Intel-gfx] 3.19-rc1 errors when opening LID
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        nick <xerofoify@gmail.com>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Sat, 27 Dec 2014 12:17:58 -0800
In-Reply-To: <1818900.MY9q0yfluC@vostro.rjw.lan>
References: <201412241951.48652@pali> <549C4278.5080707@gmail.com>
	 <201412270919.49540@pali> <1818900.MY9q0yfluC@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-27 at 21:22 +0100, Rafael J. Wysocki wrote:
[]
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -589,7 +589,8 @@ static inline u32 acpi_target_system_sta
>  
>  static inline bool acpi_device_power_manageable(struct acpi_device *adev)
>  {
> -	return adev->flags.power_manageable;
> +	return adev->flags.power_manageable
> +		&& (adev->status.present || adev->status.functional);

Most code in the kernel has these logical
continuations at the end of the previous line.

> +++ linux-pm/drivers/acpi/device_pm.c
[]
> @@ -361,7 +362,7 @@ bool acpi_bus_power_manageable(acpi_hand
>  	int result;
>  
>  	result = acpi_bus_get_device(handle, &device);
> -	return result ? false : device->flags.power_manageable;
> +	return result ? false : acpi_device_power_manageable(device);

This might read better as:

	if (acpi_bus_get_device(handle, &device))
		return false;

	return acpi_device_power_manageable(device);


