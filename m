Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab3DBExA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:53:00 -0400
Received: from sauhun.de ([89.238.76.85]:32873 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759828Ab3DBEw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:52:58 -0400
Date: Tue, 2 Apr 2013 06:52:37 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] ACPI / I2C: Use parent's ACPI_HANDLE() in
 acpi_i2c_register_devices()
Message-ID: <20130402045105.GA17682@the-dreams.de>
References: <2966020.zlpeyGGUDW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2966020.zlpeyGGUDW@vostro.rjw.lan>
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

Shall this go via the I2C tree? If not, for the I2C part:

Acked-by: Wolfram Sang <wsa@the-dreams.de>

