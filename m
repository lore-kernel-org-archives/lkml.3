Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3GQGbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 02:31:00 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60053 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab3GQGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 02:30:59 -0400
Message-ID: <1374042658.26384.31.camel@x61.thuisdomein>
Subject: Re: [kconfig] results of some syntactical checks
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 08:30:58 +0200
In-Reply-To: <1374016680.26384.22.camel@x61.thuisdomein>
References: <7121962.G9xfZAqBSy@tacticalops>
	 <1374016680.26384.22.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2013 06:30:58.0270 (UTC) FILETIME=[32C4AFE0:01CE82B7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 01:18 +0200, Paul Bolle wrote:
> On Wed, 2013-07-17 at 00:34 +0200, Martin Walch wrote:
> >   Symbol: M at
> >     drivers/usb/host/Kconfig:568:0
> >     drivers/usb/misc/Kconfig:130:0
> 
> This looks odd. I think your checker doesn't like an uppercase M after
> default. There are exactly two of those in the tree.

After posting this I actually looked into this and even tested it a bit.
It turns out an uppercase 'M' isn't a valid alias for the magic 'm'
value. Your checker is right about warning for this.

> >   Symbol: N at
> >     drivers/usb/core/Kconfig:12:0
> >     drivers/usb/host/Kconfig:336:0
> >     drivers/usb/host/Kconfig:348:0
> >     drivers/staging/usbip/Kconfig:3:0
> >     drivers/staging/usbip/Kconfig:20:0
> >     drivers/staging/usbip/Kconfig:31:0
> >     drivers/staging/usbip/Kconfig:42:0
> >     drivers/staging/asus_oled/Kconfig:3:0
> >     drivers/staging/rtl8187se/Kconfig:8:0
> >     drivers/staging/rtl8192u/Kconfig:7:0
> >     drivers/staging/rtl8192e/rtl8192e/Kconfig:7:0
> >     drivers/staging/rtl8712/Kconfig:6:0
> >     drivers/staging/rtl8712/Kconfig:14:0
> >     drivers/staging/frontier/Kconfig:3:0
> >     drivers/staging/bcm/Kconfig:3:0
> >     drivers/staging/media/go7007/Kconfig:15:0
> >     drivers/staging/media/go7007/Kconfig:26:0
> >     drivers/staging/media/go7007/Kconfig:48:0
> >     drivers/staging/android/Kconfig:4:0
> >     drivers/staging/android/Kconfig:61:0
> >     arch/cris/arch-v32/drivers/Kconfig:13:0
> >     arch/cris/arch-v32/drivers/Kconfig:413:0
> >     arch/arc/Kconfig:357:0
> 
> Ditto (but I haven't actually counted the occurrences of "default N").

Lowercase 'n' is the correct magic value. But using uppercase 'N'
doesn't matter. Since there's no Kconfig symbol "N", both evaluate to
"not set" and you'll end up with the same .config file.

> My script currently finds 28 undefined symbols. That equals this result
> (given you have 2 false positive and 1 undefined choice default.)

So those 2 were actually correct positives.


Paul Bolle

