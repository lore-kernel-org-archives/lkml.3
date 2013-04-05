Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162747Ab3DEUXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:23:16 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:34284 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162728Ab3DEUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:23:13 -0400
Date: Fri, 5 Apr 2013 13:23:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130405202309.GA3303@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <20130402230042.GA8713@kroah.com>
 <20130402165340.61b7da02@chromoly>
 <20130403001300.GA13838@kroah.com>
 <20130402214818.50f1ae89@chromoly>
 <20130403163509.GC21969@kroah.com>
 <20130403103551.16e62eb6@chromoly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403103551.16e62eb6@chromoly>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 10:35:51AM -0700, Jacob Pan wrote:
> On Wed, 3 Apr 2013 09:35:09 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Apr 02, 2013 at 09:48:18PM -0700, Jacob Pan wrote:
> > > > Let's step back and start over, what exactly are you trying to
> > > > tell userspace?  What data do you have that you need to express
> > > > to it?  How do you want userspace to see/use it?
> > > 
> > > It is a good idea to step back and let me explain what I wanted to
> > > do here for userspace.
> > > 
> > > I have two kinds of applications that might use this driver.
> > > 1. simple use case where user sets a power limit for a RAPL domain.
> > > e.g. set graphics unit power limit to 7w
> > > 2. advanced use case where use can do fine tuning on top of simple
> > > power limit,e.g. the dynamic response parameters of power control
> > > logic, event notifications, etc.
> > > 
> > > For #1, this driver register with the abstract generic thermal layer
> > > (/sys/class/thermal) and presents itself as a set of cooling devices
> > > with a single knob per domain for power limits.
> > > root@chromoly:/sys/class/thermal/cooling_device15# echo 7000 >
> > > cur_state 
> > 
> > Great, how about submitting that functionality as patch 1 of your
> > series?  That seems like a very "normal" thermal driver, right?
> > 
> yes, that would be a normal thermal cooling device driver. I will do
> that first. Thanks for the suggestion.

Do that first, get it merged, and then let's work on the second part.
The patch for that will be much more obvious as to what you are
attempting to do.

> >  Perhaps the thermal interface could be expanded to provide
> > more functionality that you need?
> yes, some of them such as limits. But not all the data in the list
> above are suitable for thermal interface. That is why I am trying to
> balance between abstracted generic data and RAPL specific data while
> still allow linking between the two.

What is not in the existing interface?  And as this is a thermal device,
why can't you add them there?

> The way I envisioned how a thermal/power management app would use is:
> 1. go through generic thermal layer sysfs and find available RAPL
> domains
> 2. if the app wants to do more fine grained control, it follows the
> device symlink to locate the RAPL domain specific sysfs area.

So any application will have to know all of the device-specific
attributes?  That totally defeats the purpose of a generic api that the
kernel is providing.  You are creating device-specific apis that will
not work over the long-run (i.e. next 5-10 years.)  Please don't do that
unless you have exhausted _all_ other alternatives.

So, get your first driver accepted, using the in-kernel thermal api, and
then, if you still feel you wish to do device-specific extensions, we
can discuss that then.

greg k-h
