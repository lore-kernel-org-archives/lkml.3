Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaB1AQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:16:56 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41655 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaB1AQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:16:54 -0500
X-Greylist: delayed 119920 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 19:16:54 EST
X-Originating-IP: 50.43.14.201
Date: Thu, 27 Feb 2014 16:16:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] bug: Make BUG() call unreachable()
Message-ID: <20140228001645.GA29605@thin>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
 <201402261429.06553.arnd@arndb.de>
 <20140226145806.GA24150@thin>
 <201402272019.47554.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402272019.47554.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:19:47PM +0100, Arnd Bergmann wrote:
> On Wednesday 26 February 2014, Josh Triplett wrote:
> > This doesn't seem any different than compiling out assert() at runtime
> > in a userspace program, given how the kernel uses BUG() and BUG_ON().
> > I'd argue that adding unreachable() doesn't seem like it makes the
> > current implementation of BUG() any worse; either way if you reach it
> > you have a problem.
> 
> I think it's better to get a warning about undefined behavior than
> to suppress that warning.

Then at this point I'm going to suggest that you go ahead and submit the
patch you want on top of the first four patches of this series.  Please
keep in mind the value and code size savings of !CONFIG_BUG, versus
CONFIG_BUG=y and !CONFIG_DEBUG_BUGVERBOSE; those mean two different
things.

Meanwhile: Andrew, could you go ahead and apply the first four patches?

- Josh Triplett
