Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaHLJxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:53:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:62380 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaHLJxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,848,1400050800"; 
   d="scan'208";a="557329992"
Date: Tue, 12 Aug 2014 12:53:21 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, torvalds@linux-foundation.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Make I2C core able to be module when I2C_ACPI is
 selected.
Message-ID: <20140812095321.GU1657@lahna.fi.intel.com>
References: <1407740455-21269-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407740455-21269-1-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 03:00:55PM +0800, Lan Tianyu wrote:
> Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
> config) adds a new kernel config I2C_ACPI and make I2C core built in
> when the config is selected. This is wrong because distributions
> etc generally compile I2C as a module and the commit broken that.
> This patch is to make I2C core able to be a module when I2C_ACPI is
> selected. Original issue the commit da3c6647 tried to avoid will
> be fixed in ACPICA and it's rarely triggered during unloading module. 
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

I wonder if we can do

	depends on I2C=y

here? If I understand it right, then we only build the ACPI_I2C if I2C
is compiled into the kernel. That way the problem da3c6647 tried to
solve doens't re-appear.

We can later on relax this once ACPICA has been fixed. Thoughts?
