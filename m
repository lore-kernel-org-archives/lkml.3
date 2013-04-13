Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3DMBMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:12:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3DMBMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:12:08 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8YNFhi1qPlwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dkCXd7rf6f8A:10 a=t8pxu81T_Ci53JOa1SoA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365815526.9609.101.camel@gandalf.local.home>
Subject: Re: [ 026/171 ] sfc: Only use TX push if a single descriptor is to
 be written
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 12 Apr 2013 21:12:06 -0400
In-Reply-To: <1365804331.2791.11.camel@bwh-desktop.uk.solarflarecom.com>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202550.471143447@goodmis.org>
	 <1365714957.7355.39.camel@bwh-desktop.uk.solarflarecom.com>
	 <1365804331.2791.11.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 23:05 +0100, Ben Hutchings wrote:
> On Thu, 2013-04-11 at 22:15 +0100, Ben Hutchings wrote:
> > Aside from #21-26 in this series, and the deadlock fix required on top
> > of #24, there are several more fixes for sfc that I think are suitable
> > for 3.6.11.y.
> > 
> > These commits were cherry-picked for 3.4.38 and can also be
> > cherry-picked cleanly on top of 3.6.11.1 plus the 7 patches you already
> > have:
> > 
> > d5e8cc6c946e sfc: Really disable flow control while flushing
> > bfeed902946a sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
> > 9724a8504c87 sfc: Add parentheses around use of bitfield macro arguments
> > 0a6e5008a9df sfc: Fix MCDI structure field lookup
> > 450783747f42 sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
> > 525d9e824018 sfc: Work-around flush timeout when flushes have completed
> > ef492f11efed sfc: Correctly initialise reset_method in siena_test_chip()
> > ebf98e797b4e sfc: Fix timekeeping in efx_mcdi_poll()
> > 
> > Please let me know whether you're prepared to include these in the
> > current update.  I can then run some automated tests with your selected
> > set of patches applied.
> 
> The test suite found a regression which I'd forgotten about.  It
> was introduced in 3.6 by commit b7f514af7d6f 'sfc: Fix interface
> statistics running backward' and fixed in 3.8 by commit 876be083b669
> 'sfc: Reset driver's MAC stats after MC reboot seen'.
> 
> That latter fix is, again, a clean cherry-pick onto 3.6.y.  I don't
> think I'm going to be able to re-test with this but it's sufficiently
> low-risk that I'd be happy for you to add it anyway.

Thanks!

I included it, and will run some simple tests. If everything works, I'll
just keep it without another spamming of the mailing lists.

I wont post till after my 3.6.11.2-rt tests passes.

-- Steve


