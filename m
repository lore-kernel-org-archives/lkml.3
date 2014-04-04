Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaDDSe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:34:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:65145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaDDSe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:34:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,796,1389772800"; 
   d="scan'208";a="507155407"
Date: Fri, 4 Apr 2014 21:42:32 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140404184232.GC19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
 <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:20:39PM +0300, Du, Wenkai wrote:
> In current driver implementation, I2c controller is enabled, then
> disabled every time inside i2c_dw_xfer. So I think the interrupt masking
> should be done inside i2c_dw_xfer_init, where the controller is enabled.

Interrupt masking is done already after each transaction.

The problem here is that after reset, the interrupt mask register gets
0x8ff value (HW default), which means that most of the interrupts are left
unmasked.

That is the reason why this only happens right after we resume from
system sleep. Masking interrupts on that path fixes the problem.
