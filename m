Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3BDEcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:32:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:8127 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3BDEcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:32:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,596,1355126400"; 
   d="scan'208";a="257199561"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, "Li, Fei" <fei.li@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH V4] suspend: enable freeze timeout configuration through
 sys
Thread-Topic: [PATCH V4] suspend: enable freeze timeout configuration
 through sys
Thread-Index: AQHOAoX+KKFbUnxzdEm6tz8PxYnYSZhpGhuA
Date: Mon, 4 Feb 2013 04:32:11 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A222AEB@SHSMSX101.ccr.corp.intel.com>
References: <BEC9F67575FA1E429CA7CF5AE9BE36343F154E@SHSMSX102.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1302032213410.28934-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302032213410.28934-100000@netrider.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Monday, February 04, 2013 11:16 AM
> To: Li, Fei
> Cc: Rafael J. Wysocki; akpm@linux-foundation.org;
> linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org; Liu, Chuansheng
> Subject: RE: [PATCH V4] suspend: enable freeze timeout configuration through
> sys
> 
> On Mon, 4 Feb 2013, Li, Fei wrote:
> 
> > > -> the situation described above shouldn't happen and if it does, then there
> > > is a bug that needs to be fixed.
> >
> > Yes, we agree with that it's a bug that needs to be fixed, and we are already
> done
> > for some cases.
> > During the process, we realize that tuning the timeout value to smaller value
> will help
> > to expose freezing failure for some cases.
> 
> Besides, the underlying bug is well known (fuse filesystems hanging
> because the fuse daemon gets frozen before the process doing file I/O,
> or something like that) and so far nobody has a good idea of how to
> fix it.
Indeed, we have some well-known deadlock issues existed there.
And once there is deadlock case, this patch is helpful to the user experience,
because 20s is pointless for those deadlock case.

Also even adjusting the 20s to 2s, we still can get to know the process stack who rejecting the freezing,
so this freezing configuration is really helpful to avoid 20s waiting for that deadlock case.
Alan and Rafael, could you consider this patch? Thanks.
> 
> Alan Stern

