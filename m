Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaDWGru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:47:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:4089 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaDWGri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:47:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="497867055"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "awilliam@redhat.com" <awilliam@redhat.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [Resend Patch 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
Thread-Topic: [Resend Patch 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
Thread-Index: AQHPXreSgGS3xgSloUeGGwRYvnOORJseuzMQ
Date: Wed, 23 Apr 2014 06:47:05 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88025577CB@SHSMSX101.ccr.corp.intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-10-git-send-email-tianyu.lan@intel.com>
 <20140422114510.GM30677@intel.com> <53575227.7080407@intel.com>
In-Reply-To: <53575227.7080407@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3N6mRYT016066

Hi, Tianyu

> From: Lan, Tianyu
> Sent: Wednesday, April 23, 2014 1:40 PM
> 
> On 2014å¹´04æœˆ22æ—¥ 19:45, Mika Westerberg wrote:
> > On Tue, Apr 22, 2014 at 02:24:15PM +0800, Lan Tianyu wrote:
> >> This patch is to add CONFIG_I2C_ACPI. Current there is a race between
> >> removing I2C ACPI operation region and ACPI AML code accessing.
> >> So make i2c core built-in if CONFIG_I2C_ACPI is set.
> >>
> >> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> >> ---
> >>  drivers/i2c/Kconfig  | 17 ++++++++++++++++-
> >>  drivers/i2c/Makefile |  2 +-
> >>  include/linux/i2c.h  |  2 +-
> >>  3 files changed, 18 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> >> index 7b7ea32..c670d49 100644
> >> --- a/drivers/i2c/Kconfig
> >> +++ b/drivers/i2c/Kconfig
> >> @@ -2,7 +2,9 @@
> >>  # I2C subsystem configuration
> >>  #
> >>
> >> -menuconfig I2C
> >> +menu "I2C support"
> >> +
> >> +config I2C
> >>  	tristate "I2C support"
> >>  	select RT_MUTEXES
> >>  	---help---
> >> @@ -21,6 +23,17 @@ menuconfig I2C
> >>  	  This I2C support can also be built as a module.  If so, the module
> >>  	  will be called i2c-core.
> >>
> >> +config I2C_ACPI
> >> +	bool "I2C ACPI support"
> >> +	select I2C
> >> +	depends on ACPI
> >> +	default y
> >> +	help
> >> +	  Say Y here if you want to enable I2C ACPI function. ACPI table
> >> +	  provides I2C slave devices' information to enumerate these devices.
> >> +	  This option also allows ACPI AML code to access I2C slave devices
> >> +	  via I2C ACPI operation region to fulfill ACPI method.
> >> +
> >
> > I'm wondering, can we provide some sort of wrapper function from ACPI core
> > that is guaranteed to be built in to the kernel image and use it instead of
> > adding new Kconfig options?
> >
> Cc: LV
> 
> LV tried to fix the issue via wrapper solution in the ACPI code before.
> https://lkml.org/lkml/2013/7/23/87
> 
> He has a plan to resolve the issue in ACPICA later.
> 
> Other choice is to increase the i2c-core module count to prevent it
> being unloaded when i2c operation region handler is installed. Remove
> the code When LV finish his job.

You may see it implemented in ACPICA after several release.
If you need a fix for now, you can use the patch pointed to by the link you've provided,
Or you could find an updated one here:
 acpi-ipmi13.patch archived in (https://bugzilla.kernel.org/attachment.cgi?id=112611)

I think the solution you've provided in this patch is also reasonable for now.
IPMI also uses a similar solution to solve this issue.
Please refer to the CONFIG_ACPI_IPMI.

The story can be found at:
http://www.spinics.net/lists/linux-acpi/msg49044.html
And the similar solution can be found at:
http://www.spinics.net/lists/linux-acpi/msg49184.html

Thanks and best regards
-Lv

> 
> --
> Best regards
> Tianyu Lan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
