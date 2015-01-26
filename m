Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbbAZKjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:39:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:8096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbbAZKjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,468,1418112000"; 
   d="scan'208";a="667550899"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Pavel Machek <pavel@ucw.cz>, "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Change behaviour when tracing ... nasty trap (was Re: [PATCH]
 PM/Trace: get rid of synchronous resume limit during PM trace)
Thread-Topic: Change behaviour when tracing ... nasty trap (was Re: [PATCH]
 PM/Trace: get rid of synchronous resume limit during PM trace)
Thread-Index: AQHQOVI4WhHuql6TR0OwGyzNDtsW5ZzSNSqA
Date: Mon, 26 Jan 2015 10:39:04 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01F1AD6A@SHSMSX101.ccr.corp.intel.com>
References: <54C5CB77.4000109@linux.intel.com> <20150126102352.GA1758@amd>
In-Reply-To: <20150126102352.GA1758@amd>
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

Hello Pavel,

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Monday, January 26, 2015 6:24 PM
> To: Fu, Zhonghui
> Cc: Rafael J. Wysocki; Brown, Len; Greg Kroah-Hartman;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: Change behaviour when tracing ... nasty trap (was Re: [PATCH]
> PM/Trace: get rid of synchronous resume limit during PM trace)
> 
> On Mon 2015-01-26 13:07:03, Fu, Zhonghui wrote:
> > >From f9c841d1f943d81b5ab0aac7483e794a7f966296 Mon Sep 17 00:00:00
> 2001
> > From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> > Date: Mon, 26 Jan 2015 11:27:08 +0800
> > Subject: [PATCH] PM/Trace: get rid of synchronous resume limit during PM
> trace
> >
> > There are some kind of dependency between devices in some
> > hardware platforms. So, asynchronous resuming devices may
> > hang system due to wrong resume order. As a result, should
> > not fore synchronously resuming devices during tracing
> > PM events.
> >
> > Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> > ---
> >  drivers/base/power/main.c    |    3 +--
> >  include/linux/resume-trace.h |    7 -------
> >  2 files changed, 1 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > index 9717d5f..5df148b 100644
> > --- a/drivers/base/power/main.c
> > +++ b/drivers/base/power/main.c
> > @@ -517,8 +517,7 @@ static int device_resume_noirq(struct device *dev,
> pm_message_t state, bool asyn
> >
> >  static bool is_async(struct device *dev)
> >  {
> > -	return dev->power.async_suspend && pm_async_enabled
> > -		&& !pm_trace_is_enabled();
> > +	return dev->power.async_suspend && pm_async_enabled;
> >  }
> >
> 
> Actually... whoever did the original patch was evil person. Changing
> behaviour when tracing is requested is evil, evil, evil. Git blame
> tells me
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> 
> went to the dark side.

Although I didn't get where is something wrong, but the is_async() is not created by my commit,
it is from commit (PM: Start asynchronous resume threads upfront), I just moved it ahead.

And like other phases, I added it into resum/suspend_noirq()...
