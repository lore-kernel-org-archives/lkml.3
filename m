Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3FHB2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:28:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:20352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125Ab3FHB2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:28:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,825,1363158000"; 
   d="scan'208";a="349971853"
Message-ID: <1370655020.4432.83.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH 0/2] Run callback of device_prepare/complete consistently
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, shuox.liu@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, pavel@ucw.cz,
        len.brown@intel.com
Date: Sat, 08 Jun 2013 09:30:20 +0800
In-Reply-To: <20130608011625.GB2819@kroah.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
	 <2482951.doztFClhed@vostro.rjw.lan>
	 <1370652132.4432.68.camel@ymzhang.sh.intel.com>
	 <20130608011625.GB2819@kroah.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 18:16 -0700, Greg KH wrote:
> On Sat, Jun 08, 2013 at 08:42:12AM +0800, Yanmin Zhang wrote:
> > On Fri, 2013-06-07 at 12:36 +0200, Rafael J. Wysocki wrote:
> > > On Friday, June 07, 2013 04:20:30 PM shuox.liu@intel.com wrote:
> > > > dpm_run_callback is used in other stages of power states changing.
> > > > It provides debug info message and time measurement when call these
> > > > callback. We also want to benefit ->prepare and ->complete.
> > > > 
> > > > [PATCH 1/2] PM: use dpm_run_callback in device_prepare
> > > > [PATCH 2/2] PM: add dpm_run_callback_void and use it in device_complete
> > > 
> > > Is this an "Oh, why don't we do that?" series, or is it useful for anything
> > > in practice?  I'm asking, because we haven't added that stuff to start with
> > > since we didn't see why it would be useful to anyone.
> > > 
> > > And while patch [1/2] reduces the code size (by 1 line), so I can see some
> > > (tiny) benefit from applying it, patch [2/2] adds more code and is there any
> > > paractical reason?
> > Sometimes, suspend-to-ram path spends too much time (either suspend slowly
> > or wakeup slowly) and we need optimize it.
> > With the 2 patches, we could collect initcall_debug printk info and manually
> > check what prepare/complete callbacks consume too much time.
> 
> But initcall information is for initialization stuff, not suspend/resume
> things, right? 
initcall_debug also controls shutdown callbacks, and suspend/resume callbacks.
See __device_suspend=>dpm_run_callback. It's very useful when we want to optimize
suspend-to-ram, or debug some hard issues which happen when async suspend is enabled.

>  Doesn't the existing tools for parsing this choke if it
> sees the information at suspend/resume time?
Current kernel doesn't print out info around prepare/complete.


