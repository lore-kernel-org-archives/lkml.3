Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3GPD2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:28:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:50305 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3GPD2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:28:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,673,1367996400"; 
   d="scan'208";a="370849545"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: RE: [PATCH] i2c-designware: Manually set RESTART bit between
 messages
Thread-Topic: [PATCH] i2c-designware: Manually set RESTART bit between
 messages
Thread-Index: AQHOftzKzfbnLSyyqU+ObCkVY3vUeplmqCEw
Date: Tue, 16 Jul 2013 03:27:13 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA014C347F@PGSMSX103.gar.corp.intel.com>
References: <1371798328-31931-1-git-send-email-chiaue.ee.chew@intel.com>
 <20130703201510.GB2958@katana> <20130704074121.GD4898@intel.com>
In-Reply-To: <20130704074121.GD4898@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
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
> > If both IC_EMPTYFIFO_HOLD_MASTER_EN and IC_RESTART_EN are set to 1, 
> > the Designware I2C controller doesn't generate RESTART unless user 
> > specifically requests it by setting RESTART bit in IC_DATA_CMD register.
> > 
> > Since IC_EMPTYFIFO_HOLD_MASTER_EN setting can't be detected from 
> > hardware register, we must always manually set the restart bit between messages.
> > 
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> How come restart has worked before? Or did it not?

> It works fine. However IC_EMPTYFIFO_HOLD_MASTER_EN=1 makes a difference. We had similar thing with the STOP that was fixed previously.

>If I understand the dw i2c databook right, RESTART is only issued if the transfer direction changes. So if you have two or more consecutive transfers that have the same direction (not sure how common that is) there is no RESTART between them unless >DW_IC_CON_RESTART_EN is set.

>Chiau Ee, does this fix a real problem?

Yes, it fixed a problem in one of our use case. we have a use case whereby the control path of the audio codec is using I2C bus. During our validation based on that use case,  we observed there is issue with back-to-back message transfer if this fix is not being added.
