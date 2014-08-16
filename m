Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHPA1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 20:27:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51547 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751301AbaHPA1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 20:27:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: markus@gutschke.com
Cc: Zhang Rui <rui.zhang@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
Date: Sat, 16 Aug 2014 02:46:39 +0200
Message-ID: <1558893.86R7jAYGB3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALGCz1ofVwspov3QU1rk3z5HBRuDuKxwk1Qkx2xM3vFAVLzS2g@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com> <CALGCz1p8=gPBqf6z-YpRzSE=raNJmJw-OKCsLwne3raCr4Y-1g@mail.gmail.com> <CALGCz1ofVwspov3QU1rk3z5HBRuDuKxwk1Qkx2xM3vFAVLzS2g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 15, 2014 10:17:42 AM Markus Gutschke wrote:
> Just wondering if any of you had any other ideas of what I could try
> to help debug this problem?

My theory is that there is a device in your system that we don't have a driver
for, but it had been enumerated as a PNP device before the change that triggered
the problem for you and we turned it off during suspend as part of the default
ACPI PNP device handling.

The reason why you're seeing a crash with the "platform" test level is most
likely that the _WAK control method does something unusual on your system.

The LNXSYBUS:00 thing from dmesg probably is a red herring.

I need the output of acpidump from the affected system, but please attach it
to the bug entry at https://bugzilla.kernel.org/show_bug.cgi?id=80911 that
Rui has created for this issue.

Also please check the list of PNP devices under

/sys/bus/pnp/devices/

before and after the commit you have found by bisection and let me know if
there are any differences.


> On Tue, Aug 12, 2014 at 9:11 AM, Markus Gutschke <markus@gutschke.com> wrote:
> > As I said earlier in this thread, echo'ing "devices" into "pm_test"
> > does not result in a crash; but doing so for "platform" does.
> >
> > Markus
> >
> > On Aug 12, 2014 1:26 AM, "Zhang Rui" <rui.zhang@intel.com> wrote:
> >>
> >> On Sat, 2014-08-09 at 03:14 -0700, Markus Gutschke wrote:
> >> > I am back and have physical access to the machine now.
> >> >
> >> great!
> >>
> >> > I re-ran the test just to be sure, and I can confirm that "platform"
> >> > does in fact result in a crash.
> >> >
> >> what about "devices"?
> >> I mean
> >>
> >> # echo devices > /sys/power/pm_test
> >>
> >> and see if that triggers the crash.
> >>
> >> > Furthermore, I ran the test that Rui asked for. I suspended, resumed,
> >> > and upon crashing power-cycled the machine ASAP. "dmesg" suggests that
> >> > the problem is with LNXSYBUS:00 That doesn't tell me much, but
> >> > hopefully it makes sense to you guys.
> >> >
> >> [    0.930093]   Magic number: 10:810:122
> >> [    0.930185] acpi LNXSYBUS:00: hash matches
> >>
> >> This looks weird, ACPI will do nothing for LNXSYBUS devices during
> >> resume.
> >> Rafael, any thought on this?
> >>
> >> thanks,
> >> rui
> >>

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
