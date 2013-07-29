Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3G2VXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:23:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:56623 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab3G2VX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,773,1367996400"; 
   d="scan'208";a="353829685"
Date: Mon, 29 Jul 2013 14:23:28 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch error on trace events macros
Message-ID: <20130729212328.GD14883@xanatos>
References: <20130729195201.GC14883@xanatos>
 <1375128164.2075.53.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375128164.2075.53.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 01:02:44PM -0700, Joe Perches wrote:
> On Mon, 2013-07-29 at 12:52 -0700, Sarah Sharp wrote:
> > Hi Andy and Joe,
> 
> Hi Sarah.
> 
> > Checkpatch is complaining when code adds new trace events macros:
> > 
> > sarah@xanatos:~/git/kernels/xhci$ git am -s ~/Maildir.fetchmail/.to-apply
> > Applying: xhci: add traces for debug messages in xhci_address_device()
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #86: FILE: drivers/usb/host/xhci-trace.h:15:
> > +#define TRACE_SYSTEM xhci-hcd
> 
> <shrug>
> 
> I think these are suboptimal as the files should use
> underscores rather than dashes.

The norm in the USB subsystem is to use dashes in filenames.  I think
it's suboptimal to have to use the shift key at all when typing
filenames.  We have different preferences here, and different reasons
for those preferences, but there is no "should" here, just opinions.

> checkpatch sees this as a subtraction which really
> should have parentheses.

I see.

> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #115: FILE: drivers/usb/host/xhci-trace.h:44:
> > +#define TRACE_INCLUDE_PATH .
> > 
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #118: FILE: drivers/usb/host/xhci-trace.h:47:
> > +#define TRACE_INCLUDE_FILE xhci-trace
> 
> Don't expect to checkpatch to be perfect.
> 
> It's not.
> 
> It's a stupid little tool good for some things
> and good for highlighting areas that might need
> another look.
> 
> Use your judgment about everything it spews.

If checkpatch spews warnings and errors,  that makes it basically
useless as a git pre-commit hook.

Sigh, I suppose I'll just add a '|| true' to the end of the line and
deal with it.

Sarah Sharp
