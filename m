Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaKTO1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:27:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:55571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbaKTO1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:27:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,424,1413270000"; 
   d="scan'208";a="640431861"
Date: Thu, 20 Nov 2014 16:27:30 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, shigorin@gmail.com,
        adamw@happyassassin.net, jan.brummer@tabos.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devel@acpica.org
Subject: Re: [PATCH V2] ACPI: Add _DEP(Operation Region Dependencies) support
 to fix battery issue on the Asus T100TA
Message-ID: <20141120142730.GP1309@lahna.fi.intel.com>
References: <1416492733-18597-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416492733-18597-1-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:12:12PM +0800, Lan Tianyu wrote:
> ACPI 5.0 introduces _DEP to designate device objects that OSPM should
> assign a higher priority in start ordering due to future operation region
> accesses.
> 
> On Asus T100TA, ACPI battery info are read from a I2C slave device via
> I2C operation region. Before I2C operation region handler is installed,
> battery _STA always returns 0. There is a _DEP method of designating
> start order under battery device node.
> 
> This patch is to implement _DEP feature to fix battery issue on the Asus T100TA.
> Introducing acpi_dep_list and adding dep_unmet count in the struct
> acpi_device. During ACPI namespace scan, create struct acpi_dep_data for a
> valid pair of master (device pointed to by _DEP)/slave(device with _DEP), record
> master's and slave's ACPI handle in it and put it into acpi_dep_list. The dep_unmet
> count will increase by one if there is a device under its _DEP. Driver's probe() should
> return EPROBE_DEFER when find dep_unmet is larger than 0. When I2C operation
> region handler is installed, remove all struct acpi_dep_data on the acpi_dep_list
> whose master is pointed to I2C host controller and decrease slave's dep_unmet.
> When dep_unmet decreases to 0, all _DEP conditions are met and then do acpi_bus_attach()
> for the device in order to resolve battery _STA issue on the Asus T100TA.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=69011
> Tested-by: Jan-Michael Brummer <jan.brummer@tabos.org>
> Tested-by: Adam Williamson <adamw@happyassassin.net>
> Tested-by: Michael Shigorin <shigorin@gmail.com>
> Acked-by: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Looks good to me now,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
