Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaCJLfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:35:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:18134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbaCJLfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:35:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,623,1389772800"; 
   d="scan'208";a="495404160"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA
 hold time value
Thread-Topic: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA
 hold time value
Thread-Index: AQHPO3Z29tlwWgDHfUmXNkFYhTpCNpraL3hA
Date: Mon, 10 Mar 2014 11:34:49 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA0155D5C4@PGSMSX103.gar.corp.intel.com>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
 <20140309090339.GB4695@katana>
In-Reply-To: <20140309090339.GB4695@katana>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Sunday, March 09, 2014 5:04 PM
> To: Chew, Chiau Ee
> Cc: Mika Westerberg; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA
> hold time value
> 
> On Fri, Mar 07, 2014 at 10:12:51PM +0800, Chew Chiau Ee wrote:
> > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> >
> > On Intel BayTrail, there was case whereby the resulting fast mode bus
> > speed becomes slower (~20% slower compared to expected speed) if using
> > the HCNT/LCNT calculated in the core layer. Thus, this patch is added
> > to allow pci glue layer to pass in optimal HCNT/LCNT/SDA hold time
> > values to core layer since the core layer supports cofigurable
> > HCNT/LCNT/SDA hold time values now.
> >
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> Can you make use of those instead?
> 
>         u32                     sda_falling_time;
>         u32                     scl_falling_time;
> 
> This is more consistent with using sda_hold_time and lets them have a common
> (and more readable) unit.

Would like to clarify on your statement above. So you are suggesting to change the following 
variable name in the code? As in:
"u32 ss_hcnt;"   to  "u32 ss_scl_rising_time"
"u32 fs_hcnt;"   to  "u32 fs_scl_rising_time"
"u32 ss_lcnt;"    to   "u32 ss_scl_falling_time"
"u32 fs_lcnt;"     to " u32 fs_scl_falling_time"
"u32 sda_hold;"  to  "u32 sda_hold_time"

