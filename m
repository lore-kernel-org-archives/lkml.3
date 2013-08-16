Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3HPWfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:35:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54353 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3HPWfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:02 -0400
Date: Fri, 16 Aug 2013 15:40:55 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Message-ID: <20130816204055.GK4035@joshc.qualcomm.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
 <20130816184614.GA31510@kroah.com>
 <20130816194714.GH4035@joshc.qualcomm.com>
 <20130816195849.GA17974@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816195849.GA17974@kroah.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 12:58:49PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 16, 2013 at 02:47:15PM -0500, Josh Cartwright wrote:
> > > > +#ifdef CONFIG_DEBUG_FS
> > > 
> > > Why?  If debugfs isn't enabled, the functions should just compile away
> > > with the debugfs_() calls, so no need to do this type of thing here,
> > > right?
> > 
> > Not sure I follow you, but it may be because this is a bit misleading.
> > 
> > Currently CONFIG_DEBUG_FS is being extended to also mean "do you want
> > the SPMI core to create device entries?".  It would probably make more
> > sense to have a CONFIG_SPMI_DEBUG option which is def_bool DEBUG_FS, as
> > other busses have.
> > 
> > The #ifdef here would then be #ifdef CONFIG_SPMI_DEBUG, as well as in
> > the Makefile:
> > 
> >   spmi-core-$(CONFIG_SPMI_DEBUG) += spmi-dbgfs.o
> 
> If debugfs is enabled why wouldn't you want debugfs entries for your
> devices?  Don't assume a user is going to be able to rebuild their
> kernel just for debugging stuff (hint, they usually aren't), so having
> these present, if they don't cause any performance issues, is usually
> best to always have around.

Okay, that makes sense.

So, backing up a step, you're original comment was regarding the
CONFIG_DEBUG_FS conditional in spmi-dbgfs.h:

On Fri, Aug 16, 2013 at 11:46:14AM -0700, Greg Kroah-Hartman wrote:
> > --- /dev/null
> > +++ b/drivers/spmi/spmi-dbgfs.h
> > @@ -0,0 +1,37 @@
> > +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#ifndef _SPMI_DBGFS_H
> > +#define _SPMI_DBGFS_H
> > +
> > +#include <linux/spmi.h>
> > +#include <linux/debugfs.h>
> > +
> > +#ifdef CONFIG_DEBUG_FS
> 
> Why?  If debugfs isn't enabled, the functions should just compile away
> with the debugfs_() calls, so no need to do this type of thing here,
> right?

The reason why this is done is because the spmi debugfs support code is
is only built-in when CONFIG_DEBUG_FS is set.

Would you rather it always be built-in (well, whenever SPMI support is
included), and rely on the debugfs_* shims to handle the
!CONFIG_DEBUG_FS case?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
