Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3A0MhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:37:15 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:39494 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A0MhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:37:10 -0500
Date: Sun, 27 Jan 2013 12:37:06 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Azat Khuzhin <dohardgopro@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Carlos R. Mafra" <crmafra2@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>
Subject: Re: ACPI errors with 3.7-rc3
Message-ID: <20130127123706.GA1431@linux-ahr8.site>
References: <20121031014527.GA2984@kroah.com>
 <20121108044715.GA12652@kroah.com>
 <20130126122337.GA20930@linux-ahr8.site>
 <2216175.k6K6lbz85j@vostro.rjw.lan>
 <20130126133937.GA2795@linux-ahr8.site>
 <CAAW1UO81LXbrhXOApoKYC+z7DR2Tg7dAdinXy4UsWhfWH7gdYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAW1UO81LXbrhXOApoKYC+z7DR2Tg7dAdinXy4UsWhfWH7gdYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013 at  1:23:17 +0400, Azat Khuzhin wrote:
> Carlos, did you try this patch?
> 
> https://bugzilla.kernel.org/attachment.cgi?id=73510

I started to test it now and I will try to have an uptime of
more than 7 days in order to have a veridict.

[ The problem is that I started to encounter a dvb-related issue
  which requires me to reboot after trying to watch tv, so let's wee
  what happens. ]

> On Sat, Jan 26, 2013 at 5:39 PM, Carlos R. Mafra <crmafra@gmail.com> wrote:
> > On Sat, 26 Jan 2013 at 14:23:12 +0100, Rafael J. Wysocki wrote:
> >> On Saturday, January 26, 2013 12:23:37 PM Carlos R. Mafra wrote:
> >> > On Thu,  8 Nov 2012 at  5:47:15 +0100, Greg KH wrote:
> >> > > On Wed, Nov 07, 2012 at 10:49:40PM +0100, Rafael J. Wysocki wrote:
> >> > > > On Tuesday, November 06, 2012 01:48:26 PM Greg KH wrote:
> >> > > > > On Tue, Nov 06, 2012 at 04:42:24PM +0400, Azat Khuzhin wrote:
> >> > > > > > I'v also have such errors on my macbook pro.
> >> > > > > >
> >> > > > > > $ dmesg | tail
> >> > > > > > [17056.008564] ACPI Error: Method parse/execution failed
> >> > > > > > [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
> >> > > > > > (20120711/psparse-536)
> >> > > > > > [17056.011194] ACPI Error: Method parse/execution failed
> >> > > > > > [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
> >> > > > > > (20120711/psparse-536)
> >> > > > > > [17056.013793] ACPI Error: Method parse/execution failed
> >> > > > > > [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
> >> > > > > > (20120711/psparse-536)
> >> > > > > > [17056.016383] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
> >> > > > > > [17056.511373] ACPI: EC: input buffer is not empty, aborting transaction
> >> > > > > > [17056.512672] ACPI Exception: AE_TIME, Returned by Handler for
> >> > > > > > [EmbeddedControl] (20120711/evregion-501)
> >> > > > > > [17056.515256] ACPI Error: Method parse/execution failed
> >> > > > > > [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
> >> > > > > > (20120711/psparse-536)
> >> > > > > > [17056.517886] ACPI Error: Method parse/execution failed
> >> > > > > > [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
> >> > > > > > (20120711/psparse-536)
> >> > > > > > [17056.520479] ACPI Error: Method parse/execution failed
> >> > > > > > [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
> >> > > > > > (20120711/psparse-536)
> >> > > > > > [17056.523070] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
> >> > > > >
> >> > > > > I'm seeing this again right now.  I'm wondering if it's because I'm
> >> > > > > running on battery power at the moment:
> >> > > > >
> >> > > > > [41694.309264] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20120913/evregion-501)
> >> > > > > [41694.309282] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88045cc64618), AE_TIME (20120913/psparse-536)
> >> > > > > [41694.309300] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff88045cc64988), AE_TIME (20120913/psparse-536)
> >> > > > > [41694.309310] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88045cc648c0), AE_TIME (20120913/psparse-536)
> >> > > > > [41694.309324] ACPI Exception: AE_TIME, Evaluating _BST (20120913/battery-464)
> >> > > > > [41694.809093] ACPI: EC: input buffer is not empty, aborting transaction
> >> > > > >
> >> > > > > ec_storm_threshold is still set to 8 in /sys/module/acpi/parameters/ so that's
> >> > > > > not the issue here.
> >> > > > >
> >> > > > > > And also loadavg is too high ~ 10
> >> > > > > > While there is no process that load CPU up to 100% or like that.
> >> > > > > > I think that this because of processes that is done in kernel space.
> >> > > > > > (basically that one who write such errors)
> >> > > > > >
> >> > > > > > $ uname -a
> >> > > > > > Linux macbook-pro-sq 3.6.5macbook-pro-custom-v0.1 #4 SMP Sun Nov 4
> >> > > > > > 12:39:03 UTC 2012 x86_64 GNU/Linux
> >> > > > >
> >> > > > > Ah, ok, that means it's not something new in 3.7-rc, so maybe it's just never
> >> > > > > worked properly for this hardware :)
> >> > > > >
> >> > > > > So it's not a regression, just an ACPI issue, any ACPI developer have an idea
> >> > > > > about this?
> >> > > >
> >> > > > Can you please send the output of acpidump from the affected machine(s)?
> >> > >
> >> > > # ./acpidump
> >> > > ACPI tables were not found. If you know location of RSD PTR table (from dmesg, etc), supply it with either --addr or -a option
> >> > >
> >> > > What am I doing wrong here?
> >> > >
> >> > > Is there a newer version of pmtools than the one labled pmtools-20071116
> >> > > that I should be using?  A link to download it would be appreciated.
> >> >
> >> > I'd like to ask what happened to this issue, because I'm seeing similar
> >> > messages on latest 3.8-rc4 as well, and I cannot read the battery
> >> > info anymore once this happens and the laptop does not suspend to RAM
> >> > anymore -- it suspends fine before these messages.
> >> >
> >> > The laptop is a Macbook Pro with retina display and I'm using the
> >> > develpoment version of openSUSE 12.3 updated as of yesterday.
> >> >
> >> > Here is the output from dmesg:
> >> >
> >> > [49367.993080] ACPI: EC: input buffer is not empty, aborting transaction
> >> > [49367.993091] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20121018/evregion-501)
> >> > [49367.993112] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff880264490920), AE_TIME (20121018/psparse-537)
> >> > [49367.993136] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff8802644905b0), AE_TIME (20121018/psparse-537)
> >> > [49367.993147] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff880264490678), AE_TIME (20121018/psparse-537)
> >> > [49367.993166] ACPI Exception: AE_TIME, Evaluating _BST (20121018/battery-492)
> >> > [49368.491802] ACPI: EC: input buffer is not empty, aborting transaction
> >> > [49368.491812] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20121018/evregion-501)
> >> > [49368.491833] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff880264490920), AE_TIME (20121018/psparse-537)
> >> > [49368.491857] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff8802644905b0), AE_TIME (20121018/psparse-537)
> >> > [49368.491869] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff880264490678), AE_TIME (20121018/psparse-537)
> >> > [49368.491888] ACPI Exception: AE_TIME, Evaluating _BST (20121018/battery-492)
> >> > [49372.985311] ACPI: EC: input buffer is not empty, aborting transaction
> >> > [49372.985322] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20121018/evregion-501)
> >> > [49372.985344] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff880264490920), AE_TIME (20121018/psparse-537)
> >> > [49372.985368] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff8802644905b0), AE_TIME (20121018/psparse-537)
> >> > [49372.985380] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff880264490678), AE_TIME (20121018/psparse-537)
> >> > [49372.985400] ACPI Exception: AE_TIME, Evaluating _BST (20121018/battery-492)
> >> >
> >> > Anyone has more information about this?
> >>
> >> Is acpidump still not working?
> >
> > It works for me, I've uploaded it to
> >
> > http://www.damtp.cam.ac.uk/user/crm66/acpidump-rmbp.txt
> >
> > And my 'dmesg' from a freshly-booted 3.8-rc5 is here
> >
> > http://www.damtp.cam.ac.uk/user/crm66/dmesg-3.8-rc5.txt
> >
> >> What's under /sys/firmware/acpi/tables/ ?
> >
> > [mafra@linux-ahr8:~]$ ls /sys/firmware/acpi/tables/
> > APIC  DSDT      ECDT  FACS  MCFG  SSDT1   SSDT11  SSDT2  SSDT4  SSDT6  SSDT8
> > DMAR  dynamic/  FACP  HPET  SBST  SSDT10  SSDT12  SSDT3  SSDT5  SSDT7  SSDT9
> >
> > I should say that sometimes it takes +3 days for this problem to appear,
> > with many successful s2ram in between, sometimes it takes less than 1 day.
> > I could not figure out a pattern.
> >
> > Any other info I can provide?
> 
> 
> 
> -- 
> Azat Khuzhin
