Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3FXWlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:41:39 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51673 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3FXWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:41:37 -0400
Date: Mon, 24 Jun 2013 15:41:31 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, Dirk Griesbach <spamthis@freenet.de>
Subject: Re: [PATCH] libata-acpi: add back ACPI based hotplug functionality
Message-ID: <20130624224131.GM1918@mtj.dyndns.org>
References: <1715067.uK3nZ8ehWr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1715067.uK3nZ8ehWr@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 24, 2013 at 02:43:27PM +0200, Rafael J. Wysocki wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
> mistakenly dropped the code to register hotplug notificaion handler
> for ATA port/devices, causing regression for people using ATA bay,
> as kernel bug #59871 shows.
> 
> Fix this by adding back the hotplug notification handler registration
> code.  Since this code has to be run once and notification needs to
> be installed on every ATA port/devices handle no matter if there is
> actual device attached, we can't do this in binding time for ATA
> device ACPI handle, as the binding only occurs when a SCSI device is
> created, i.e. there is device attached.  So introduce the
> ata_acpi_hotplug_init() function to loop scan all ATA ACPI handles
> and if it is available, install the notificaion handler for it during
> ATA init time.
> 
> With the ATA ACPI handle binding to SCSI device tree, it is possible
> now that when the SCSI hotplug work removes the SCSI device, the ACPI
> unbind function will find that the corresponding ACPI device has
> already been deleted by dock driver, causing a scaring message like:
> [  128.263966] scsi 4:0:0:0: Oops, 'acpi_handle' corrupt
> Fix this by waiting for SCSI hotplug task finish in our notificaion
> handler, so that the removal of ACPI device done in ACPI unbind
> function triggered by the removal of SCSI device is run earlier when
> ACPI device is still available.
> 
> [rjw: Rebased]
> References: https://bugzilla.kernel.org/show_bug.cgi?id=59871
> Reported-bisected-and-tested-by: Dirk Griesbach <spamthis@freenet.de>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

> May I add the $subject patch to that series and push along with it?

Yes, please.

Thanks a lot!

-- 
tejun
