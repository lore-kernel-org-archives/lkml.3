Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaEST4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:56:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54750 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755131AbaEST4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:56:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Mon, 19 May 2014 22:13:02 +0200
Message-ID: <19742334.gxM0TSp0VL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405191552220.1538-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405191552220.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 19, 2014 03:53:58 PM Alan Stern wrote:
> On Mon, 19 May 2014, Jacob Pan wrote:
> 
> > > Wouldn't that go a bit too far?  It seems to be based on the
> > > assumption that all devices having no ->prepare() callback can be
> > > safely left in runtime suspend over a system suspend/resume cycle,
> > > but is that assumption actually satisfied for all such devices?
> > > 
> > yes, I agree it is risky though i don't see problems with my limited
> > testing. But on the other side, it is too strict.
> > I also tried adding .prepare( return 1;) to usb_ep_device_type pm ops,
> > that didn't work either. The reason is that ep devices don't support
> > runtime pm (disable_depth > 0). I think in this case ignore_children
> > flag should be the right indicator to ignore pm_runtime_suspended()?
> 
> Maybe it would be better to add a new flag that means "This is a 
> virtual device and the PM core can ignore it completely".

I like that idea. :-)

Rafael

