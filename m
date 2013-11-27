Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3K0Ue6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:34:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55036 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754294Ab3K0Uez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:34:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] Hook up powerclamp with PM QOS and cpuidle
Date: Wed, 27 Nov 2013 21:47:45 +0100
Message-ID: <2216977.ZlIXxP0jsM@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131127084732.00006425@unknown>
References: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com> <20131127115634.GA10022@twins.programming.kicks-ass.net> <20131127084732.00006425@unknown>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 08:47:32 AM jacob pan wrote:
> On Wed, 27 Nov 2013 12:56:34 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Nov 26, 2013 at 03:20:08PM -0800, Jacob Pan wrote:
> > > This patchset is intended to address the behavior change and
> > > efficiency loss introduced by using consolidated idle routine in
> > > powerclamp driver.
> > > 
> > > Specifically,
> > > [PATCH 3/8] idle, thermal, acpi: Remove home grown idle
> > > implementations
> > > 
> > > The motivation is that after using common idle routine, powerclamp
> > > driver can no longer pick the deepest idle state needed to conserve
> > > power. Idle state is selected by governors which can be influenced
> > > by PM QOS and other factors. This patchset hooks up powerclamp idle
> > > injection with PM QOS and eventually influce idle governors to pick
> > > the power saving target states.
> > > 
> > > There are some downside of this approach. Due to overhead,
> > > communication with PM QOS is at enable/disable idle injection time
> > > instead of each injection period. The implication is that if the
> > > system natual idle is more than target injected idle, powerclamp
> > > will skip some injection period. During this period however,
> > > deepest idle state may still be chosen necessarily regardless the
> > > latency constraint.
> > 
> > Does the QoS stuff have a means of notifying its users of constraints
> > violation? I suspect some applications might light to be told if their
> > requests aren't honoured.
> > 
> Each class has a notifier. This patchset is calling the notifier
> when the qos class is disable/enable. the receiver of these
> notifications are in the kernel.
> 
> I don't see the qos core code has a way to signal userspace about
> target change.

But user space can add constraints and expect them to be actually satisfied.
If those constraints cannot be satisfied, there should be a mechanism to
notify the processes who set them about that.  That mechanism is not present
currently.

Thanks,
Rafael

