Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3JEIDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 04:03:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:17931 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3JEIDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 04:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1038,1371106800"; 
   d="scan'208";a="303475596"
Date: Sat, 5 Oct 2013 11:09:01 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, rjw@rjwysocki.net,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4] i2c: enable runtime PM for I2C adapter devices
 enumerated from ACPI
Message-ID: <20131005080901.GQ28875@intel.com>
References: <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
 <1380632982-10709-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380632982-10709-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 04:09:42PM +0300, Mika Westerberg wrote:
> The ACPI specification requires the parent device to be powered on before
> any of its children. It can be only powered off when all the children are
> already off.
> 
> Currently whenever there is no I2C traffic going on, the I2C controller
> driver can put the device into low power state transparently to its
> children (the I2C client devices). This violates the ACPI specification
> because now the parent device is in lower power state than its children.
> 
> In order to keep ACPI happy we enable runtime PM for the I2C adapter device
> if we find out that the I2C controller was in fact an ACPI device. In
> addition to that we attach the I2C client devices to the ACPI power domain
> and make sure that they are powered on when the driver ->probe() is called.

It looks like Windows actually powers the I2C controller off independently
of the I2C client power state. We should probably do the same in Linux even
though it is not following what the ACPI spec says (but makes sense with
serial buses like I2C and SPI).

Wolfram, please don't apply this patch - we are going to do one more
iteration but this time we only attach devices to the ACPI power domain and
leave runtime PM alone.
