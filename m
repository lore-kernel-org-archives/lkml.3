Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaDEGGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 02:06:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:56851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbaDEGF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 02:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,799,1389772800"; 
   d="scan'208";a="487701985"
Date: Sat, 5 Apr 2014 09:13:16 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140405061316.GF19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
 <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
 <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 12:54:33AM +0300, Du, Wenkai wrote:
> >Interrupt masking is done already after each transaction.
> 
> At end of transfer, the code uses __i2c_dw_enable(dev, false) to disable
> adapter. This function doesn't mask interrupts. There is another function
> i2c_dw_disable that masks and clears interrupts. This could be used, but
> that means we need to fix in 2 places: 

Please check i2c_dw_isr() and tell me in which code path interrupts are not
getting masked. Or am I missing something fundamental here?

In case of abort, we mask interrupts. Also whenever the transaction
completes we mask interrupts (in i2c_dw_xfer_msg()).

Only place where we didn't do that, as far as I can tell, is right after
reset because of the HW default value that unmasks most of them.
