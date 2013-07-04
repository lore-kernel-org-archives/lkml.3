Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3GDHgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:36:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:21760 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3GDHgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:36:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,993,1363158000"; 
   d="scan'208";a="263980192"
Date: Thu, 4 Jul 2013 10:41:21 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Chew Chiau Ee <chiaue.ee.chew@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [PATCH] i2c-designware: Manually set RESTART bit between messages
Message-ID: <20130704074121.GD4898@intel.com>
References: <1371798328-31931-1-git-send-email-chiaue.ee.chew@intel.com>
 <20130703201510.GB2958@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703201510.GB2958@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 10:15:11PM +0200, Wolfram Sang wrote:
> 
> CCing Mika and Christian.
> 
> On Fri, Jun 21, 2013 at 03:05:28PM +0800, Chew Chiau Ee wrote:
> > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > 
> > If both IC_EMPTYFIFO_HOLD_MASTER_EN and IC_RESTART_EN are set to 1, the
> > Designware I2C controller doesn't generate RESTART unless user specifically
> > requests it by setting RESTART bit in IC_DATA_CMD register.
> > 
> > Since IC_EMPTYFIFO_HOLD_MASTER_EN setting can't be detected from hardware
> > register, we must always manually set the restart bit between messages.
> > 
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> How come restart has worked before? Or did it not?

It works fine. However IC_EMPTYFIFO_HOLD_MASTER_EN=1 makes a difference. We
had similar thing with the STOP that was fixed previously.

If I understand the dw i2c databook right, RESTART is only issued if the
transfer direction changes. So if you have two or more consecutive
transfers that have the same direction (not sure how common that is) there
is no RESTART between them unless DW_IC_CON_RESTART_EN is set.

Chiau Ee, does this fix a real problem?
