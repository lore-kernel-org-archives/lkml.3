Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3IIQ4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:56:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60772 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3IIQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:56:37 -0400
Date: Mon, 9 Sep 2013 11:56:04 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC v2 2/5] spmi: Linux driver framework for SPMI
Message-ID: <20130909165604.GM808@joshc.qualcomm.com>
References: <cover.1377202730.git.joshc@codeaurora.org>
 <46db5901fe4d04d09cee8fd81ea1c62068ee9503.1377202730.git.joshc@codeaurora.org>
 <20130822231054.GA31973@kroah.com>
 <20130823160625.GP4035@joshc.qualcomm.com>
 <20130909155224.GQ29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909155224.GQ29403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Mark-

Thanks for the comments.

On Mon, Sep 09, 2013 at 04:52:24PM +0100, Mark Brown wrote:
> On Fri, Aug 23, 2013 at 11:06:25AM -0500, Josh Cartwright wrote:
> > On Thu, Aug 22, 2013 at 04:10:54PM -0700, Greg Kroah-Hartman wrote:
> > > On Fri, Aug 09, 2013 at 01:37:09PM -0700, Josh Cartwright wrote:
> 
> > > > +	"Example: Read 4 bytes starting at register address 0x1234 for SID 2\n"
> > > > +	"\n"
> > > > +	"echo 0x21234 > address\n"
> > > > +	"echo 4 > count\n"
> > > > +	"cat data\n"
> > > > +	"\n"
> > > > +	"Example: Write 3 bytes starting at register address 0x1008 for SID 1\n"
> > > > +	"\n"
> > > > +	"echo 0x11008 > address\n"
> > > > +	"echo 0x01 0x02 0x03 > data\n"
> > > > +	"\n"
> > > > +	"Note that the count file is not used for writes.  Since 3 bytes are\n"
> > > > +	"written to the 'data' file, then 3 bytes will be written across the\n"
> > > > +	"SPMI bus.\n\n";
> 
> > > The help file within the kernel is a nice touch :)
> 
> > > Or is this only for "debugging"?  If so, please document it as such.
> 
> > It's there because it provides a useful interface for debugging of the
> > controller code, and for simple peek/poke of the slave registers without
> > having a full driver in place.  Will document this.
> 
> This looks awfully like a version of the debugfs interfaces that regmap
> provides, and indeed the entire bus sounds like something that could
> idiomatically be supported via regmap.  Have you considered doing that?
> This would give access to standard tracepoints as well, plus the cache
> infrastructure.

It does indeed look like regmap might work out nicely for SPMI.  I
hadn't seriously considered it just due to a lack of familiarity. I'll
give it a shot and see if I run into any problems.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
