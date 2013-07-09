Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3GIJZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:25:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:58841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab3GIJZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:25:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1027,1363158000"; 
   d="scan'208";a="367324408"
Date: Tue, 9 Jul 2013 12:30:45 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC][PATCH 5/8] ACPI / hotplug / PCI: Unified notify handler
 for hotplug events
Message-ID: <20130709093045.GJ4898@intel.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
 <1475924.SZkPqZAdKY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475924.SZkPqZAdKY@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 02:19:04AM +0200, Rafael J. Wysocki wrote:
> Index: linux-pm/drivers/pci/hotplug/acpiphp.h
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
> +++ linux-pm/drivers/pci/hotplug/acpiphp.h
> @@ -137,6 +137,7 @@ struct acpiphp_context {
>  	acpi_handle handle;
>  	struct acpiphp_func *func;
>  	struct acpiphp_bridge *bridge;
> +	bool handler_for_func:1;

Hmm, should it be just plain:

	bool handler_for_func;

? What's the reason using bitfields for bool?

>  };
