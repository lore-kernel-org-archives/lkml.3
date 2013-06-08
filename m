Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3FHBQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:16:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59781 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab3FHBQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:16:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: yanmin_zhang@linux.intel.com
Cc: shuox.liu@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 0/2] Run callback of device_prepare/complete consistently
Date: Sat, 08 Jun 2013 03:25:56 +0200
Message-ID: <1702720.J5FJvyF57u@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370654233.4432.75.camel@ymzhang.sh.intel.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com> <1477527.x1Afvfmi0d@vostro.rjw.lan> <1370654233.4432.75.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 08, 2013 09:17:13 AM Yanmin Zhang wrote:
> On Sat, 2013-06-08 at 02:54 +0200, Rafael J. Wysocki wrote:
> > On Saturday, June 08, 2013 08:42:12 AM Yanmin Zhang wrote:
> > > On Fri, 2013-06-07 at 12:36 +0200, Rafael J. Wysocki wrote:
> > > > On Friday, June 07, 2013 04:20:30 PM shuox.liu@intel.com wrote:
> > > > > dpm_run_callback is used in other stages of power states changing.
> > > > > It provides debug info message and time measurement when call these
> > > > > callback. We also want to benefit ->prepare and ->complete.
> > > > > 
> > > > > [PATCH 1/2] PM: use dpm_run_callback in device_prepare
> > > > > [PATCH 2/2] PM: add dpm_run_callback_void and use it in device_complete
> > > > 
> > > > Is this an "Oh, why don't we do that?" series, or is it useful for anything
> > > > in practice?  I'm asking, because we haven't added that stuff to start with
> > > > since we didn't see why it would be useful to anyone.
> > > > 
> > > > And while patch [1/2] reduces the code size (by 1 line), so I can see some
> > > > (tiny) benefit from applying it, patch [2/2] adds more code and is there any
> > > > paractical reason?
> > > Sometimes, suspend-to-ram path spends too much time (either suspend slowly
> > > or wakeup slowly) and we need optimize it.
> > > With the 2 patches, we could collect initcall_debug printk info and manually
> > > check what prepare/complete callbacks consume too much time.
> > 
> > Well, can you point me to a single driver where prepare/complete causes this
> > type of problems to happen?
> 
> That's a good question. We are enabling Android mobiles and need optimize
> suspend-to-ram. In the current upstream, we don't find a driver's prepare/complete
> callback spends too much time.

I understand your needs, but I don't think prepare/complete are likely to take
too much time on Android either.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
