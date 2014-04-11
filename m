Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaDKJW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:22:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:11502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbaDKJWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:22:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,841,1389772800"; 
   d="scan'208";a="519043386"
Date: Fri, 11 Apr 2014 12:29:56 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'Wolfram Sang'" <wsa@the-dreams.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] i2c-designware: Mask all interrupts during i2c
 controller enable
Message-ID: <20140411092956.GE19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A547FF93E0@ORSMSX110.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A547FF93E0@ORSMSX110.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 02:03:19AM +0300, Du, Wenkai wrote:
> Hi all,
> 
> Updated problem descriptions from Mika's feedback and new test data: 
> 
> There have been "i2c_designware 80860F41:00: controller timed out" errors
> on a number of Baytrail platforms. The issue is caused by incorrect value in
> Interrupt Mask Register (DW_IC_INTR_MASK)  when i2c core is being enabled. 
> This causes call to __i2c_dw_enable() to immediately start the transfer which
> leads to timeout. There are 3 failure modes observed:
> 
> 1. Failure in S0 to S3 resume path
> 
> The default value after reset for DW_IC_INTR_MASK is 0x8ff. When we start 
> the first transaction after resuming from system sleep, TX_EMPTY interrupt 
> is already unmasked because of the hardware default.
> 
> 2. Failure in normal operational path
> 
> This failure happens rarely and is hard to reproduce. Debug trace showed that
> DW_IC_INTR_MASK had value of 0x254 when failure occurred, which meant 
> TX_EMPTY was unmasked.
> 
> 2. Failure in S3 to S0 suspend path

This should probably be 3.

> This failure also happens rarely and is hard to reproduce. Adding debug trace
> that read DW_IC_INTR_MASK made this failure not reproducible. But from ISR 
> call trace we could conclude TX_EMPTY was unmasked when problem occurred.
> 
> 
> The patch masks all interrupts before the controller is enabled to resolve the
> faulty DW_IC_INTR_MASK conditions.
> 
> Signed-off-by: Wenkai Du <wenkai.du@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
