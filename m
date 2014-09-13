Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaIMGeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 02:34:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:9314 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaIMGef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 02:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,516,1406617200"; 
   d="scan'208";a="598963154"
Date: Sat, 13 Sep 2014 09:34:31 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REGRESSION] i2c-acpi: Fix NULL Pointer dereference
Message-ID: <20140913063431.GJ10854@lahna.fi.intel.com>
References: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 09:09:47PM +0200, Peter Huewe wrote:
> If adapter->dev.parent == NULL there is a NULL pointer dereference in
> acpi_i2c_install_space_handler and acpi_i2c_remove_space_handler.
> 
> This is present since introduction of this code:
> 366047515c6e "i2c: rework kernel config I2C_ACPI" or even
> da3c6647ee08 "I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI"
> 
> The adapter->dev.parent == NULL case is valid for the i2c_stub,
> so loading i2c_stub with ACPI_I2C_OPREGION enabled results in an oops.
> This is also valid at least for i2c_tiny_usb and i2c_robotfuzz_osif.
> 
> Fix by checking whether it is null before calling ACPI_HANDLE.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
