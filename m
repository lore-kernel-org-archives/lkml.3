Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3JONcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:32:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:8364 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758819Ab3JONcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,499,1378882800"; 
   d="scan'208";a="374984938"
Date: Tue, 15 Oct 2013 06:31:54 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Borislav Petkov <bp@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        LKML <linux-kernel@vger.kernel.org>, acme@redhat.com,
        dhowells@redhat.com, gthelen@google.com,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v1] tools/thermal: Introduce tmon, a tool for thermal
 subsystem
Message-ID: <20131015063154.3f7eb99c@ultegra>
In-Reply-To: <20131015091401.GA8013@pd.tnic>
References: <1381791747-7458-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1381791747-7458-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20131015091401.GA8013@pd.tnic>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 11:14:01 +0200
Borislav Petkov <bp@suse.de> wrote:

> On Mon, Oct 14, 2013 at 04:02:27PM -0700, Jacob Pan wrote:
> > Increasingly, Linux is running on thermally constrained devices.
> > The simple thermal relationship between processor and fan has
> > become past for modern computers.
> > 
> > As hardware vendors cope with the thermal constraints on their
> > products, more sensors are added, new cooling capabilities are
> > introduced. The complexity of the thermal relationship can grow
> > exponentially among cooling devices, zones, sensors, and trip
> > points. They can also change dynamically.
> > 
> > To expose such relationship to the userspace, Linux generic thermal
> > layer introduced sysfs entry at /sys/class/thermal with a matrix of
> > symbolic links, trip point bindings, and device instances. To
> > traverse such matrix by hand is not a trivial task. Testing is also
> > difficult in that thermal conditions are often exception cases that
> > hard to reach in normal operations.
> > 
> > TMON is conceived as a tool to help visualize, tune, and test the
> > complex thermal subsystem.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  tools/Makefile              |   15 +-
> >  tools/thermal/tmon/Makefile |   47 ++++
> >  tools/thermal/tmon/README   |   50 ++++
> >  tools/thermal/tmon/pid.c    |  131 +++++++++
> >  tools/thermal/tmon/sysfs.c  |  596
> > ++++++++++++++++++++++++++++++++++++++++
> > tools/thermal/tmon/tmon.8   |  142 ++++++++++
> > tools/thermal/tmon/tmon.c   |  352 ++++++++++++++++++++++++
> > tools/thermal/tmon/tmon.h   |  204 ++++++++++++++
> > tools/thermal/tmon/tui.c    |  638
> > +++++++++++++++++++++++++++++++++++++++++++ 9 files changed, 2173
> > insertions(+), 2 deletions(-) create mode 100644
> > tools/thermal/tmon/Makefile create mode 100644
> > tools/thermal/tmon/README create mode 100644
> > tools/thermal/tmon/pid.c create mode 100644
> > tools/thermal/tmon/sysfs.c create mode 100644
> > tools/thermal/tmon/tmon.8 create mode 100644
> > tools/thermal/tmon/tmon.c create mode 100644
> > tools/thermal/tmon/tmon.h create mode 100644
> > tools/thermal/tmon/tui.c
> 
> Just a couple of notes/questions:
> 
thanks for the review and feedback.
> * Why does this have to be in the kernel src repo? I mean, it only
> needs stable sysfs interface but other than that, it can very well be
> a separate project on github or so. Or am I missing something?
> 
the main customers of this tool are thermal driver developers and
thermal subsystem maintainers. one of the features i will
add is to automate the testing with temperature emulation, all these
are tied with sysfs as well as some platform data.
> * So I tried it and I can control the brightness and the target CPU
> temperature, cool! :) The question is: can I cook my box with it or
> there are protections like filtering values which might be detrimental
> to the system? After all, I'm running it as root.
> 
the hardware/fw based protection is always there. If you choose
to turn off your fan and try run your laptop fanless (passive cooling
only) and see what happens it may reach some critical condition then
shutdown. But the tool does not do anything more than what kernel ABI
and BIOS already allow you to do as root.
> * Also, please run this through checkpatch first:
> 
>   total: 1 errors, 0 warnings, 91 checks, 2202 lines checked
> 
hmm, i did that. what version of kernel did you use checkpatch?
jacob@ultegra:~/localDev/src/linux/tools$ cd ..
$ ./scripts/checkpatch.pl ../patches/tmon2/0001-tools-thermal-Introduce-tmon-a-tool-for-thermal-subs.patch 
total: 0 errors, 0 warnings, 2202 lines checked

../patches/tmon2/0001-tools-thermal-Introduce-tmon-a-tool-for-thermal-subs.patch
has no obvious style problems and is ready for submission.

>   Also, the manpage should be checked for typos and excessive spaces.
> 
ok, i will double check.

> Thanks.
> 

[Jacob Pan]
