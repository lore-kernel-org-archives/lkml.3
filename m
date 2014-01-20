Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaATLIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:08:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:40088 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaATLIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:08:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="441613471"
Date: Mon, 20 Jan 2014 13:15:19 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT][PATCH 4/5] ACPI / LPSS: Support for device latency
 tolerance PM QoS
Message-ID: <20140120111518.GE18029@intel.com>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan>
 <12327024.lrSi2qfq01@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12327024.lrSi2qfq01@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 03:46:40PM +0100, Rafael J. Wysocki wrote:
> @@ -415,11 +472,12 @@ static int acpi_lpss_platform_notify(str
>  		return 0;
>  	}
>  
> -	if (action == BUS_NOTIFY_ADD_DEVICE)
> +	if (action == BUS_NOTIFY_ADD_DEVICE) {
>  		ret = sysfs_create_group(&pdev->dev.kobj, &lpss_attr_group);
> -	else if (action == BUS_NOTIFY_DEL_DEVICE)
> +		pdev->dev.power.set_latency_tolerance = acpi_lpss_set_ltr;

While trying to test this I noticed that BUS_NOTIFY_ADD_DEVICE happens
after call to dpm_sysfs_add(), so LTR field is never exposed to the
userspace.

> +	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
>  		sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
> -
> +	}
>  	return ret;
>  }
>  
