Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab3CSCFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:05:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:23454 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab3CSCFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:05:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,868,1355126400"; 
   d="scan'208";a="216188601"
From: "Li, Fei" <fei.li@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] pm: print the name of failed suspend function for
 platform device
Thread-Topic: [PATCH] pm: print the name of failed suspend function for
 platform device
Thread-Index: AQHOI53lRkiX49rtFESAxLhF45thJpirF2cAgAEiOaA=
Date: Tue, 19 Mar 2013 02:05:02 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE3634421912@SHSMSX102.ccr.corp.intel.com>
References: <1363586303.9792.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130318160514.GE3887@kroah.com>
In-Reply-To: <20130318160514.GE3887@kroah.com>
Accept-Language: en-US
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

> > Print more info when platform device suspend function failed.
> > Without this patch, we can not get the real platform device suspend
> > API info.
> >
> > Example without this patch:
> > pm_op(): platform_pm_suspend+0x0/0x50 returns -11
> > PM: Device power.0 failed to suspend: error -11
> >
> > And with this patch:
> > platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
> > pm_op(): platform_pm_suspend+0x0/0x80 returns -11
> > PM: Device power.0 failed to suspend: error -11
> 
> How does that help someone out?  One extra line?  What is that going to
> allow a user to now do?
>
Thanks for your comments.

The intention is to print relatively complete call path for convenience of
debugging in case of error. With this, we can know the exact name of
the concrete failed function.
Besides, currently such information is printed with level KERN_ERR,
and can be tuned through console_loglevel to avoid the possible impact
to end user.

Do you think it make sense?

Thanks and Regards,
Li Fei

> greg k-h
