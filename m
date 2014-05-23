Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaEWMxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:53:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57816 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753139AbaEWMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:53:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Mike Turquette <mturquette@linaro.org>, Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/4] ACPI / LPSS: custom power domain for LPSS
Date: Fri, 23 May 2014 15:10:08 +0200
Message-ID: <13101534.gKoyQa16hJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140523123052.GA18308@xps8300>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com> <1484699.LPqrzmlevB@vostro.rjw.lan> <20140523123052.GA18308@xps8300>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 23, 2014 03:30:53 PM Heikki Krogerus wrote:
> On Thu, May 22, 2014 at 01:28:16AM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, May 21, 2014 01:52:58 PM Heikki Krogerus wrote:
> > > On Wed, May 21, 2014 at 01:01:31PM +0200, Rafael J. Wysocki wrote:
> > > > On Wednesday, May 21, 2014 01:05:11 PM Heikki Krogerus wrote:
> > > > > On Tue, May 20, 2014 at 11:33:09PM +0200, Rafael J. Wysocki wrote:
> > > > > > First, is the 10 ms sleep really necessary?  I'd expect the AML to take care of
> > > > > > such delays (this is not a PCI device formally).
> > > > > 
> > > > > Unfortunately that is not the case. There is nothing in the AML for
> > > > > this. Mika, correct me if I'm wrong.
> > > > > 
> > > > > > And because this is not a PCI device formally, why is the comment talking about
> > > > > > the PCI spec?  Why is PCI relevant in any way here?
> > > > > 
> > > > > Under the hood the devices are still PCI devices, even if they
> > > > > formally aren't. Maybe I should point that out in the comment..
> > > > > 
> > > > > We put the sleep there because without it there was no guarantee if
> > > > > the device was properly resumed by the time the drivers resume hooks
> > > > > were called. The symptom in case of a failure was simply that the
> > > > > registers could not be written, which leads into timeouts at least in
> > > > > case of the I2C and UART and making them unusable until the next
> > > > > suspend followed by resume.
> > > > 
> > > > OK, so the msleep() is functionally necessary.  Instead of talking about the
> > > > PCI in the comment, which will make a casual reader think "What the heck?",
> > > > please say something like "the delay is necessary for the subsequent register
> > > > writes to succeed on <example system>".
> > > 
> > > OK.
> > 
> > So I have one more concern.  Namely, async suspend is not enabled for the LPSS
> > devices, so the delays will accumulate for them and that may become a big deal
> > at one point.
> > 
> > This may be addressed either (1) by enabling async suspend for them or, which would
> > be more complicated, by doing the msleep() once for the whole LPSS in .resume_early()
> > and restoring the register values in .resume() without delaying.
> > 
> > For (1) I have the following untested patch (on top of my bleeding-edge branch, but
> > it should apply to the mainline too if I haven't overlooked anything).  Can you
> > please try it on boxes with LPSS and see if it doesn't break suspend/resume on them?
> 
> Done, and there were no problems. I tested it with HSW, BYT and also BDW.

Great, thanks!

So I'll add a changelog and I'm going to push it along with your series.

Are you going to update the $subject patch, or send an update on top of
linux-next?

Rafael

