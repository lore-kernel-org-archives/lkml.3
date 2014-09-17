Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaIQCCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:02:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43838 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaIQCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:01:59 -0400
Date: Wed, 17 Sep 2014 02:26:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: suravee.suthikulpanit@amd.com
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, graeme.gregory@linaro.org,
        marc.zyngier@arm.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        astone@redhat.com, grant.likely@linaro.org, hanjun.guo@linaro.org,
        Sudeep.Holla@arm.com, olof@lixom.net, jason@lakedaemon.net
Subject: Re: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle
 SATA controller
Message-ID: <20140917012614.GA31214@srcf.ucam.org>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1410828446-28502-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410828446-28502-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:47:23PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch adds ACPI match table in ahci_platform. The table includes
> the acpi_device_id to match AMD Seattle SATA controller with following
> asl structure in DSDT:
> 
>     Device (SATA0)
>     {
>       Name(_HID, "AMDI0600")	// Seattle AHSATA

There really ought to be a well-defined PNPID for AHCI, so you can _HID 
to AMD and _CID to something generic. That way we won't have:

> +#ifdef CONFIG_ATA_ACPI
> +static const struct acpi_device_id ahci_acpi_match[] = {
> +	{ "AMDI0600", 0 }, /* AMD Seattle AHCI */
> +	{ },
> +};

utter sadness here. Really, please don't end up in a situation where we 
need to add device-specific IDs to a generic driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
