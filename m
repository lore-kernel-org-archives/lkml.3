Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3EFTqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:46:22 -0400
Received: from sisa.samsung.com ([63.166.156.250]:45097 "EHLO
	mx2.sisa.samsung.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3EFTqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:46:20 -0400
X-ASG-Debug-ID: 1367869579-051129071a0dbd0001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Thread-Topic: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call
 kfree() while holding device power lock
X-ASG-Orig-Subj: Re: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Thread-Index: AQHOSoyXedE0CiKV/Ee/GdKhNFCEcJj5A5uAgAABZAA=
Date: Mon, 6 May 2013 19:46:18 +0000
Message-ID: <1367869578.2953.57.camel@lorien>
References: <1367614010.8452.2.camel@lorien>
	 <20130504125116.GA13770@amd.pavel.ucw.cz>
	 <1882177.s6zpHZ6crc@vostro.rjw.lan>
	 <20130506120925.GA25542@amd.pavel.ucw.cz> <1367867093.2953.49.camel@lorien>
	 <20130506194119.GA15886@kroah.com>
In-Reply-To: <20130506194119.GA15886@kroah.com>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.5]
Content-Type: text/plain; charset="utf-8"
Content-ID: <349E5979C21582448C8BEF3AEEBE23A5@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1367869579
X-Barracuda-URL: http://192.168.0.102:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r46JkRIr025753

On Mon, 2013-05-06 at 12:41 -0700, gregkh@linuxfoundation.org wrote:
> On Mon, May 06, 2013 at 07:04:53PM +0000, Shuah Khan wrote:
> > dev_pm_put_subsys_data() calls kfree() while holding device power lock, when
> > the reference count is 0. Fix it to call kfree() after releasing the lock.
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> > Reviewed-by: Rafael Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/base/power/common.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Is this causing a problem now, and it should go into 3.10 and earlier
> kernels (if so, which ones?), or can it just wait until 3.11 as it's
> just a cleanup fix?

It can wait until 3.11. At this point I don't have any evidence that
this is actually causing problems. So please treat this as a cleanup fix
found during code review.

thanks,
-- Shuah

-- 
Shuah Khan Lead Kernel Developer - Open Source Group 
Samsung Research America (Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
