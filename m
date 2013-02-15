Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab3BOIeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:34:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:40555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3BOIeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:34:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,671,1355126400"; 
   d="scan'208";a="202705134"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Andreas Mohr <andi@lisas.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
Thread-Topic: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
Thread-Index: AQHOCsHF9Z6vRnNAfUas0eTwR3aiyph6mNAQ
Date: Fri, 15 Feb 2013 08:34:07 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926329ED25@SHSMSX101.ccr.corp.intel.com>
References: <20130214144404.GA20011@rhlx01.hs-esslingen.de>
In-Reply-To: <20130214144404.GA20011@rhlx01.hs-esslingen.de>
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

Can you please attach your config file?

Thanks,
rui

> -----Original Message-----
> From: Andreas Mohr [mailto:andi@lisas.de]
> Sent: Thursday, February 14, 2013 10:44 PM
> To: Zhang, Rui
> Cc: linux-kernel@vger.kernel.org
> Subject: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
> Importance: High
> 
> Hi,
> 
> I just had a
> 
> # cat /sys/class/thermal/thermal_zone0/policy
> (null)
> 
> 
> When looking at the code (on my -rc7), I saw:
> 
> drivers/thermal/thermal_sys.c
> 
> static ssize_t
> policy_show(struct device *dev, struct device_attribute *devattr, char
> *buf)
> {
>         struct thermal_zone_device *tz = to_thermal_zone(dev);
> 
>         return sprintf(buf, "%s\n", tz->governor->name);
> }
> 
> 
> (not sure though why I manage to get a "(null)" rather than a crash
> due to the dereferencing prior to output - possibly since I do have a
> valid governor allocated yet then only its name field is null?)
> 
> 
> Seems we are missing a critical (and -rc-relevant) patch here
> (and perhaps at other locations in this file, too, given that
> this one was missed last time?).
> 
> Currently trying to get acerhdf operation into a working state
> (and having some trouble with it - didn't know that I probably need
> some
> governor setup which seems to have just been available on my last setup,
> or so)
> 
> Thanks,
> 
> Andreas Mohr
