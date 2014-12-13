Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966182AbaLMIb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:31:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966150AbaLMIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:31:26 -0500
Date: Sat, 13 Dec 2014 09:31:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
Message-ID: <20141213083123.GA26129@amd>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
 <20141213025530.GO21347@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213025530.GO21347@ld-irv-0074>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-12 18:55:30, Brian Norris wrote:
> Hi Rafael,
> 
> On Wed, Sep 03, 2014 at 04:55:35PM -0700, Brian Norris wrote:
> > When CONFIG_PM_DEBUG=y, we provide a sysfs file (/sys/power/pm_test) for
> > selecting one of a few suspend test modes, where rather than entering a
> > full suspend state, the kernel will perform some subset of suspend
> > steps, wait 5 seconds, and then resume back to normal operation.
> > 
> > This mode is useful for (among other things) observing the state of the
> > system just before entering a sleep mode, for debugging or analysis
> > purposes. However, a constant 5 second wait is not sufficient for some
> > sorts of analysis; for example, on an SoC, one might want to use
> > external tools to probe the power states of various on-chip controllers
> > or clocks.
> > 
> > This patch adds a companion sysfs file (/sys/power/pm_test_delay) that
> > allows user-space to configure how long the system waits in this test
> > state before resuming. It also updates the PM debugging documentation to
> > mention the new file.
> > 
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> 
> What do you think about this patch? It seems there is at least one other
> developer who is independently interested in this.

40 lines of code, and new sysfs interface for use by someone who puts
the probes on board, anyway... (so should be able to add the single
mdelay himself).

Does not struck me as a good balance.
								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
