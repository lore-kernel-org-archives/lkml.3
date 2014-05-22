Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaEVJ6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:58:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:9378 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbaEVJ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,886,1392192000"; 
   d="scan'208";a="543261614"
Date: Thu, 22 May 2014 12:58:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 10/11] ACPI: use platform bus as the default bus for
 _HID enumeration
Message-ID: <20140522095823.GE1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
 <1400136256-2218-11-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400136256-2218-11-git-send-email-rui.zhang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:44:15PM +0800, Zhang Rui wrote:
> +static void acpi_do_default_enumeration(struct acpi_device *device)
> +{
> +	/*
> +	 * Do not do enumeration for device object that has been/will be
> +	 * enumerated by its parent.
> +	 */
> +	if (device->parent && device->parent->flags.is_master_device)
> +		return;
> +
> +	/* Do not do enumeration for device object with scan handler attached */
> +	if (device->handler)
> +		return;
> +
> +	/* Do not do enumeration for device object w/o platform_id */
> +	if (!device->pnp.type.platform_id)
> +		return;
> +
> +	acpi_create_platform_device(device, NULL);
> +}
> +
> +

You have an extra empty line here.
