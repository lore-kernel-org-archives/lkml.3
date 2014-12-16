Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaLPX6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:58:19 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40834 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaLPX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:58:17 -0500
Date: Tue, 16 Dec 2014 15:58:13 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
Message-ID: <20141216235813.GI9759@ld-irv-0074>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
 <20141213025530.GO21347@ld-irv-0074>
 <20141213083123.GA26129@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213083123.GA26129@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 09:31:23AM +0100, Pavel Machek wrote:
> On Fri 2014-12-12 18:55:30, Brian Norris wrote:
> > On Wed, Sep 03, 2014 at 04:55:35PM -0700, Brian Norris wrote:
> > > When CONFIG_PM_DEBUG=y, we provide a sysfs file (/sys/power/pm_test) for
> > > selecting one of a few suspend test modes, where rather than entering a
> > > full suspend state, the kernel will perform some subset of suspend
> > > steps, wait 5 seconds, and then resume back to normal operation.
> > > 
> > > This mode is useful for (among other things) observing the state of the
> > > system just before entering a sleep mode, for debugging or analysis
> > > purposes. However, a constant 5 second wait is not sufficient for some
> > > sorts of analysis; for example, on an SoC, one might want to use
> > > external tools to probe the power states of various on-chip controllers
> > > or clocks.
> > > 
> > > This patch adds a companion sysfs file (/sys/power/pm_test_delay) that
> > > allows user-space to configure how long the system waits in this test
> > > state before resuming. It also updates the PM debugging documentation to
> > > mention the new file.
> > > 
> > > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> > 
> > What do you think about this patch? It seems there is at least one other
> > developer who is independently interested in this.
> 
> 40 lines of code, and new sysfs interface for use by someone who puts
> the probes on board, anyway... (so should be able to add the single
> mdelay himself).

I heard your complaint the first time:

  https://lkml.org/lkml/2014/9/4/63

And I responded to it already:

  https://lkml.org/lkml/2014/9/4/494

You did not respond, but Chirantan spoke up saying he wanted such a
patch too. He came up with a very similar solution independently:

  https://chromium.googlesource.com/chromiumos/third_party/kernel/+/15bccc2c63c3475ef61d3187c73ccf1d80b18c7e

But since you've decided to make the same comment again, I will detail
more of the reasons why I think your suggestion ("go add the mdelay
yourself") is off-base.

 1. This is behind a debug config option (CONFIG_PM_DEBUG). So what's
 the problem with improving its usefulness? Non-debug users can easily
 compile it out if they're worried about 40 lines.

 2. The current debug code encodes a particular policy (which kernels
 generally should not). Is it better if I submit a patch that changes
 the current magic delay to 60000 milliseconds? What about 1334
 milliseconds?

 3. To continue your argument: why would I ever try to patch the
 upstream kernel, if I'm perfectly capable of doing this myself?

 4. How does putting probes on a board suddenly qualify someone for
 patching and rebuilding their kernel? I noted that I have *users* who
 want to do this. Hence, I'm patching a *user* interface.

Brian
