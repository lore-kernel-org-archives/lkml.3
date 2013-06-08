Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3FHBTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 21:19:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:32302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3FHBTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 21:19:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,825,1363158000"; 
   d="scan'208";a="346635424"
Message-ID: <1370654512.4432.79.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH 1/2] PM: use dpm_run_callback in device_prepare
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: shuox.liu@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl,
        len.brown@intel.com, Zhang Yanmin <yanmin.zhang@intel.com>
Date: Sat, 08 Jun 2013 09:21:52 +0800
In-Reply-To: <20130608011518.GA2819@kroah.com>
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
	 <1370593232-3602-2-git-send-email-shuox.liu@intel.com>
	 <20130607173706.GA29615@kroah.com>
	 <1370652235.4432.70.camel@ymzhang.sh.intel.com>
	 <20130608011518.GA2819@kroah.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 18:15 -0700, Greg KH wrote:
> On Sat, Jun 08, 2013 at 08:43:55AM +0800, Yanmin Zhang wrote:
> > On Fri, 2013-06-07 at 10:37 -0700, Greg KH wrote:
> > > On Fri, Jun 07, 2013 at 04:20:31PM +0800, shuox.liu@intel.com wrote:
> > > > From: ShuoX Liu <shuox.liu@intel.com>
> > > > 
> > > > dpm_run_callback could show more debug info around prepare stage.
> > > 
> > > Why?  Who needs this?  What problem does it solve?
> > > 
> > > Without answers to this, why would you expect us to accept such a
> > > change?
> > It's to provide more debug info and developers can quickly find what
> > prepare/complete callback consumes too much time.
> 
> What exact debug info is this providing, and why wouldn't you say all of
> this in the original changelog information?
Thanks for the reminder.

Below are examples, after applying the patches. We can see clearly
how much time every device prepare callback consumes.

[  600.384779] sr 1:0:0:0: preparing bus suspend
[  600.384780] call 1:0:0:0+ returned 0 after 2 usecs
[  600.384785] calling  2-1+ @ 2556, parent: usb2
[  600.384788] usb 2-1: preparing type suspend
[  600.384789] call 2-1+ returned 0 after 2 usecs
[  600.384794] calling  1-1.1+ @ 2556, parent: 1-1
[  600.384797] usb 1-1.1: preparing type suspend
[  600.384799] call 1-1.1+ returned 0 after 2 usecs
[  600.384802] calling  1-1.3+ @ 2556, parent: 1-1
[  600.384804] usb 1-1.3: preparing type suspend
[  600.384805] call 1-1.3+ returned 0 after 2 usecs
[  600.384809] calling  1-1.4+ @ 2556, parent: 1-1
[  600.384811] usb 1-1.4: preparing type suspend
[  600.384813] call 1-1.4+ returned 0 after 2 usecs
[  600.384816] calling  1-1.5+ @ 2556, parent: 1-1
[  600.384819] usb 1-1.5: preparing type suspend, may wakeup
[  600.384820] call 1-1.5+ returned 0 after 2 usecs
[  600.384823] calling  1-1.4.1+ @ 2556, parent: 1-1.4
[  600.384825] usb 1-1.4.1: preparing type suspend
[  600.384827] call 1-1.4.1+ returned 0 after 2 usecs
[  600.384829] calling  1-1.4.2+ @ 2556, parent: 1-1.4
[  600.384831] usb 1-1.4.2: preparing type suspend
[  600.384833] call 1-1.4.2+ returned 0 after 2 usecs
[  600.384865] PM: prepare suspend of devices complete after 0.471 msecs

