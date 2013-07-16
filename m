Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab3GPTh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:37:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:37:25 -0400
Date: Tue, 16 Jul 2013 12:32:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
Message-ID: <20130716193235.GA8142@kroah.com>
References: <51E57631.2030805@linux.intel.com>
 <20130716164459.GB17827@kroah.com>
 <51E59116.2060801@linux.intel.com>
 <20130716183149.GA6164@kroah.com>
 <51E596E7.5040504@linux.intel.com>
 <20130716190422.GA1186@kroah.com>
 <51E59FEF.90404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51E59FEF.90404@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:33:03PM -0700, Srinivas Pandruvada wrote:
> >> +Example Sys-FS Interface
> >> +
> >> +/sys/class/power_cap/intel-rapl
> >> +├── package-0
> >> +│   ├── constraint-0
> >> +│   │   ├── name
> >> +│   │   ├── power_limit_uw
> >> +│   │   └── time_window_us
> >> +│   ├── constraint-1
> >> +│   │   ├── name
> >> +│   │   ├── power_limit_uw
> >> +│   │   └── time_window_us
> >> +│   ├── core
> >> +│   │   ├── constraint-0
> >> +│   │   │   ├── name
> >> +│   │   │   ├── power_limit_uw
> >> +│   │   │   └── time_window_us
> >> +│   │   ├── energy_uj
> >> +│   │   └── max_energy_range_uj
> >> +│   ├── dram
> >> +│   │   ├── constraint-0
> >> +│   │   │   ├── name
> >> +│   │   │   ├── power_limit_uw
> >> +│   │   │   └── time_window_us
> >> +│   │   ├── energy_uj
> >> +│   │   └── max_energy_range_uj
> >> +│   ├── energy_uj
> >> +│   ├── max_energy_range_uj
> >> +│   └── max_power_range_uw
> >> +├── package-1
> >> +│   ├── constraint-0
> >> +│   │   ├── name
> >> +│   │   ├── power_limit_uw
> >> +│   │   └── time_window_us
> >> +│   ├── constraint-1
> >> +│   │   ├── name
> >> +│   │   ├── power_limit_uw
> >> +│   │   └── time_window_us
> >> +│   ├── core
> >> +│   │   ├── constraint-0
> >> +│   │   │   ├── name
> >> +│   │   │   ├── power_limit_uw
> >> +│   │   │   └── time_window_us
> >> +│   │   ├── energy_uj
> >> +│   │   └── max_energy_range_uj
> >> +│   ├── dram
> >> +│   │   ├── constraint-0
> >> +│   │   │   ├── name
> >> +│   │   │   ├── power_limit_uw
> >> +│   │   │   └── time_window_us
> >> +│   │   ├── energy_uj
> >> +│   │   └── max_energy_range_uj
> >> +│   ├── energy_uj
> >> +│   ├── max_energy_range_uj
> >> +│   └── max_power_range_uw
> >> +├── power
> >> +│   ├── async
> >> +│   ├── autosuspend_delay_ms
> >> +│   ├── control
> >> +│   ├── runtime_active_kids
> >> +│   ├── runtime_active_time
> >> +│   ├── runtime_enabled
> >> +│   ├── runtime_status
> >> +│   ├── runtime_suspended_time
> >> +│   └── runtime_usage
> >> +├── subsystem -> ../../../../class/power_cap
> >> +└── uevent
> > Ick.  Rewrite this to use a bus and you should be fine, right?  Don't
> > use a class, a class is only to be used if you have a device that is a
> > specific "type of thing".  Like a tty device, it is a class, as lots of
> > different "real" devices can have tty ports on them (usb, pci, pcmcia,
> > platform, etc.)
> >
> > Rethink this using a bus and see if that solves your issues.  You get a
> > hierarchy with that.  And you can have different "types" of devices on
> > your bus, making it easy to tell the difference between a "package" and
> > a "constraint".
> >
> > Does that help?
> I will experiment your suggestion. I see this class analogous to 
> "/sys/class/thermal",
> , where the thermal class provides a set of consistent interface for all 
> thermal devices.

But thermal devices are not "real" at all.  There are just a number of
"cooling devices" on a virtual bus and not attached to any type of a
real device at all.

There's also no hierarchy that I can see with the thermal class, but you
want to have this, so you will have to do something different because
classes do not have hierarchies.

So try using a device and a bus and see if that helps out.  If not,
please let me know.

thanks,

greg k-h
