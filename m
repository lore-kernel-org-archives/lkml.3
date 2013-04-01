Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab3DAIX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:23:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:17674 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab3DAIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,385,1363158000"; 
   d="scan'208";a="310414949"
Date: Mon, 1 Apr 2013 11:28:07 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] ACPI / I2C: Use parent's ACPI_HANDLE() in
 acpi_i2c_register_devices()
Message-ID: <20130401082807.GL21804@intel.com>
References: <2966020.zlpeyGGUDW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2966020.zlpeyGGUDW@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:25:03AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The ACPI handle of struct i2c_adapter's dev member should not be
> set, because this causes that struct i2c_adapter to be associated
> with the ACPI device node corresponding to its parent as the
> second "physical_device", which is incorrect (this happens during
> the registration of struct i2c_adapter).  Consequently,
> acpi_i2c_register_devices() should use the ACPI handle of the
> parent of the struct i2c_adapter it is called for rather than the
> struct i2c_adapter's ACPI handle (which should be NULL).
> 
> Make that happen and modify the i2c-designware-platdrv driver,
> which currently is the only driver for ACPI-enumerated I2C
> controller chips, not to set the ACPI handle for the
> struct i2c_adapter it creates.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
