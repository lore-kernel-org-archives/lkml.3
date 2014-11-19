Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaKSOSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:18:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:64918 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbaKSOSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:18:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418675920"
Date: Wed, 19 Nov 2014 16:18:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baruch Siach <baruch@tkos.co.il>, "Du, Wenkai" <wenkai.du@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: designware: prevent early stop on TX FIFO empty
Message-ID: <20141119141834.GJ1309@lahna.fi.intel.com>
References: <545CB6C4.8010201@arm.com>
 <20141119092122.GC1439@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119092122.GC1439@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:21:22AM +0100, Wolfram Sang wrote:
> On Fri, Nov 07, 2014 at 12:10:44PM +0000, Andrew Jackson wrote:
> > If the Designware core is configured with IC_EMPTYFIFO_HOLD_MASTER_EN
> > set to zero, allowing the TX FIFO to become empty causes a STOP
> > condition to be generated on the I2C bus. If the transmit FIFO
> > threshold is set too high, an erroneous STOP condition can be
> > generated on long transfers - particularly where the interrupt
> > latency is extended.

Makes sense to give some slack so that the interrupt handler is still
able to fill the FIFO.

> > 
> > Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> So, what do other designware users think of this change (nice CC list
> BTW, Andrew). Adding Mika, too.

I quickly tested this on Haswell machine with touch screen connected to
the I2C bus and it still works fine, so

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
