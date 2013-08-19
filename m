Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3HSLaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:30:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:46880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3HSLah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:30:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="389457960"
Date: Mon, 19 Aug 2013 14:36:04 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: christian.ruppert@abilis.com, linux-i2c@vger.kernel.org, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130819113604.GN4898@intel.com>
References: <20130711101330.GP4898@intel.com>
 <51DFB6C1.4040001@pobox.com>
 <20130712085140.GY4898@intel.com>
 <51E0E76B.1040304@pobox.com>
 <20130716111616.GA25835@ab42.lan>
 <51E6ACBE.7000509@pobox.com>
 <20130722131706.GA24081@ab42.lan>
 <51EFE550.1000507@pobox.com>
 <20130805093126.GE20936@ab42.lan>
 <520D8B30.9000602@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520D8B30.9000602@pobox.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:15:12AM +0900, Shinya Kuribayashi wrote:
> >Actually, the I2C specification clearly defines f_SCL;max (and thus
> >implies t_SCL;min), both in the tables and the timing diagrams. Why can
> >we ignore this constraint while having to meet all the others?
> 
> If we meet t_r, t_f, t_HIGH, t_LOW (and t_HIGH in this DW case),
> f_SCL;max will be met by itself.  And again, all I2C master and
> slave devices in the bus don't care about f_SCL; what they do care
> are t_f, t_r, t_HIGH, t_LOW, and so on.  That's why I'm saying
> f_SCL is pointless and has no value for HCNT/LCNT calculations.

One thing that comes to mind regarding the bus speed is that even if we
have all the minimal timing requirements met we still prefer resulting bus
speeds closer to 400kHz than 315.41kHz for the reasons that we get more
data transferred that way, no?
