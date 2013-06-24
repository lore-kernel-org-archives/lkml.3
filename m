Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3FXTek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:34:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49405 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3FXTei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:34:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 1/2] power: add new interface to return pm_transition state
Date: Mon, 24 Jun 2013 21:44 +0200
Message-ID: <2196353.NSocUzaxzG@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6172F2C0@sisaex02sj>
References: <1371931874-3220-1-git-send-email-shuah.kh@samsung.com> <4133846.I1XZFprb5V@vostro.rjw.lan> <B8EFE96D1287C24090BAD9D858E15E6172F2C0@sisaex02sj>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 04:20:06 PM Shuah Khan wrote:
> On 06/22/2013 03:17 PM, Rafael J. Wysocki wrote:
> > On Saturday, June 22, 2013 02:11:14 PM Shuah Khan wrote:
> >> Add a new interface get_pm_transition() to return pm_transition state.
> >> This interface is intended to be used from dev_pm_ops class and type
> >> suspend interfaces that call legacy pm ops driver suspend interfaces.
> >> Legacy suspend pm_ops take pm_message_t as a parameter.
> >>
> >> e.g: drm_class_suspend() calls into driver suspend routines
> >> via drm_dev->driver->suspend(drm_dev, state).
> >>
> >> Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
> >> have access to pm_transition which it has to pass into driver legacy
> >> suspend calls. get_pm_transition() interface addresses this need.
> >
> > That shouldn't be necessary because each transition has its own callback
> > in strict dev_pm_ops.
> >
> > Thanks,
> > Rafael
> >
> 
> Yes that is correct that there is no need pass in or know pm_transition 
> with dev_pm_ops. The issue I am running into is the legacy pm_ops class 
> suspend/resume routines call. In the example, I mentioned in my 
> changelog, drm_class_suspend() calls legacy pm_ops and passes in state. 
> It passes in the state to the driver legacy suspend routine. I have seen 
> code paths in drivers that differentiate between PM_EVENT_FREEZE, 
> PM_EVENT_SUSPEND, PM_EVENT_SLEEP etc.
> 
> I considered passing PM_EVENT_SUSPEND to 
> drm_dev->driver->suspend(drm_dev, state) from drm_class_suspend() which 
> would eliminate the need for this new interface. However, I am concerned 
> about breaking driver legacy suspend routines that key of off the state 
> to execute different code paths for PM_EVENT_FREEZE vs. 
> PM_EVENT_SUSPEND. Suspend routines get called when state is is 
> PM_EVENT_FREEZE based on my testing.
> 
> I would rather not add a new interface. Hoping you will have another 
> idea on how to pass in the state to legacy suspend/resume without adding 
> this new interface. My thinking is that this new interface is temporary 
> measure until all of the legacy suspend routines get converted to 
> dev_pm_ops and at the tile legacy interface gets removed, this new 
> interface can go away as well.

There are multiple bus types with legacy callbacks.  PCI and platform for
two examples and USB does something similar.  Please have a look at these.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
