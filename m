Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3AZMXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:23:00 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:38912 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3AZMW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:22:56 -0500
Date: Sat, 26 Jan 2013 12:23:37 +0000
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Azat Khuzhin <dohardgopro@gmail.com>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>
Subject: Re: ACPI errors with 3.7-rc3
Message-ID: <20130126122337.GA20930@linux-ahr8.site>
References: <20121031014527.GA2984@kroah.com>
 <CAAW1UO9BtAU5jpy=MqgFCwwXn3Gb8HA3m7FMktmQkYGqYrS0Rw@mail.gmail.com>
 <20121106124826.GA21806@kroah.com>
 <41011456.LYWJPCi9Xt@vostro.rjw.lan>
 <20121108044715.GA12652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108044715.GA12652@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Nov 2012 at  5:47:15 +0100, Greg KH wrote:
> On Wed, Nov 07, 2012 at 10:49:40PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 06, 2012 01:48:26 PM Greg KH wrote:
> > > On Tue, Nov 06, 2012 at 04:42:24PM +0400, Azat Khuzhin wrote:
> > > > I'v also have such errors on my macbook pro.
> > > > 
> > > > $ dmesg | tail
> > > > [17056.008564] ACPI Error: Method parse/execution failed
> > > > [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
> > > > (20120711/psparse-536)
> > > > [17056.011194] ACPI Error: Method parse/execution failed
> > > > [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
> > > > (20120711/psparse-536)
> > > > [17056.013793] ACPI Error: Method parse/execution failed
> > > > [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
> > > > (20120711/psparse-536)
> > > > [17056.016383] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
> > > > [17056.511373] ACPI: EC: input buffer is not empty, aborting transaction
> > > > [17056.512672] ACPI Exception: AE_TIME, Returned by Handler for
> > > > [EmbeddedControl] (20120711/evregion-501)
> > > > [17056.515256] ACPI Error: Method parse/execution failed
> > > > [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
> > > > (20120711/psparse-536)
> > > > [17056.517886] ACPI Error: Method parse/execution failed
> > > > [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
> > > > (20120711/psparse-536)
> > > > [17056.520479] ACPI Error: Method parse/execution failed
> > > > [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
> > > > (20120711/psparse-536)
> > > > [17056.523070] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
> > > 
> > > I'm seeing this again right now.  I'm wondering if it's because I'm
> > > running on battery power at the moment:
> > > 
> > > [41694.309264] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20120913/evregion-501)
> > > [41694.309282] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88045cc64618), AE_TIME (20120913/psparse-536)
> > > [41694.309300] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff88045cc64988), AE_TIME (20120913/psparse-536)
> > > [41694.309310] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88045cc648c0), AE_TIME (20120913/psparse-536)
> > > [41694.309324] ACPI Exception: AE_TIME, Evaluating _BST (20120913/battery-464)
> > > [41694.809093] ACPI: EC: input buffer is not empty, aborting transaction
> > > 
> > > ec_storm_threshold is still set to 8 in /sys/module/acpi/parameters/ so that's
> > > not the issue here.
> > > 
> > > > And also loadavg is too high ~ 10
> > > > While there is no process that load CPU up to 100% or like that.
> > > > I think that this because of processes that is done in kernel space.
> > > > (basically that one who write such errors)
> > > > 
> > > > $ uname -a
> > > > Linux macbook-pro-sq 3.6.5macbook-pro-custom-v0.1 #4 SMP Sun Nov 4
> > > > 12:39:03 UTC 2012 x86_64 GNU/Linux
> > > 
> > > Ah, ok, that means it's not something new in 3.7-rc, so maybe it's just never
> > > worked properly for this hardware :)
> > > 
> > > So it's not a regression, just an ACPI issue, any ACPI developer have an idea
> > > about this?
> > 
> > Can you please send the output of acpidump from the affected machine(s)?
> 
> # ./acpidump
> ACPI tables were not found. If you know location of RSD PTR table (from dmesg, etc), supply it with either --addr or -a option
> 
> What am I doing wrong here?
> 
> Is there a newer version of pmtools than the one labled pmtools-20071116
> that I should be using?  A link to download it would be appreciated.

I'd like to ask what happened to this issue, because I'm seeing similar
messages on latest 3.8-rc4 as well, and I cannot read the battery
info anymore once this happens and the laptop does not suspend to RAM
anymore -- it suspends fine before these messages.

The laptop is a Macbook Pro with retina display and I'm using the
develpoment version of openSUSE 12.3 updated as of yesterday.

Here is the output from dmesg:

[49367.993080] ACPI: EC: input buffer is not empty, aborting transaction
[49367.993091] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20121018/evregion-501)
[49367.993112] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff880264490920), AE_TIME (20121018/psparse-537)
[49367.993136] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff8802644905b0), AE_TIME (20121018/psparse-537)
[49367.993147] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff880264490678), AE_TIME (20121018/psparse-537)
[49367.993166] ACPI Exception: AE_TIME, Evaluating _BST (20121018/battery-492)
[49368.491802] ACPI: EC: input buffer is not empty, aborting transaction
[49368.491812] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20121018/evregion-501)
[49368.491833] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff880264490920), AE_TIME (20121018/psparse-537)
[49368.491857] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff8802644905b0), AE_TIME (20121018/psparse-537)
[49368.491869] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff880264490678), AE_TIME (20121018/psparse-537)
[49368.491888] ACPI Exception: AE_TIME, Evaluating _BST (20121018/battery-492)
[49372.985311] ACPI: EC: input buffer is not empty, aborting transaction
[49372.985322] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20121018/evregion-501)
[49372.985344] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff880264490920), AE_TIME (20121018/psparse-537)
[49372.985368] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff8802644905b0), AE_TIME (20121018/psparse-537)
[49372.985380] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff880264490678), AE_TIME (20121018/psparse-537)
[49372.985400] ACPI Exception: AE_TIME, Evaluating _BST (20121018/battery-492)

Anyone has more information about this?
