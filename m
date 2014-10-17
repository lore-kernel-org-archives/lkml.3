Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaJQDcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 23:32:31 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57903 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaJQDc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:32:29 -0400
Date: Fri, 17 Oct 2014 09:02:17 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Raymond Yau <superquad.vortex2@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Joe Perches <joe@perches.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 2/2] ALSA: au88x0: pr_* replaced with
 dev_*
Message-ID: <20141017033217.GA3554@sudip-PC>
References: <1412930199-24797-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1412930199-24797-2-git-send-email-sudipm.mukherjee@gmail.com>
 <CAN8ccibSw_85wdnxbNSKfjXQ-7Lg3C6_5fhKQJJi5xMi8pMabA@mail.gmail.com>
 <20141011090903.GC8231@sudip-PC>
 <1413024491.16385.10.camel@joe-AO725>
 <20141011113349.GA9962@sudip-PC>
 <1413041569.16385.20.camel@joe-AO725>
 <20141011182510.GA1917@fool>
 <CAN8cciZXLfWC-vsYq0r64Uw6D0t2z8LFVcF_i31OQg5BO7+uZQ@mail.gmail.com>
 <s5h61fkw2k7.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h61fkw2k7.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:45:44PM +0200, Takashi Iwai wrote:
> At Thu, 16 Oct 2014 11:04:34 +0800,
> Raymond Yau wrote:
<snip>
> > > > since these 2 commits:
> > > >
> > > > commit e28d713704117bca0820c732210df6075b09f13b
> > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Date:   Tue Jun 16 11:02:28 2009 -0700
> > > >
> > > >     printk: Add KERN_DEFAULT printk log-level
> > > >
> > > >     This adds a KERN_DEFAULT loglevel marker, for when you cannot decide
> > > >     which loglevel you want, and just want to keep an existing printk
> > > >     with the default loglevel.
> > > >
> > > >     The difference between having KERN_DEFAULT and having no log-level
> > > >     marker at all is two-fold:
> > > >
> > > >      - having the log-level marker will now force a new-line if the
> > > >        previous printout had not added one (perhaps because it forgot,
> > > >        but perhaps because it expected a continuation)
> > > >
> > > >      - having a log-level marker is required if you are printing out a
> > > >        message that otherwise itself could perhaps otherwise be mistaken
> > > >        for a log-level.
> > > >
> > > > and
> > > >
> > > > commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f
> > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Date:   Tue Jun 16 10:57:02 2009 -0700
> > > >
> > > >     printk: clean up handling of log-levels and newlines
> > > >
> > > >     It used to be that we would only look at the log-level in a printk()
> > > >     after explicit newlines, which can cause annoying problems when the
> > > >     previous printk() did not end with a '\n'. In that case, the
> > log-level
> > > >     marker would be just printed out in the middle of the line, and be
> > > >     seen as just noise rather than change the logging level.
> > > >
> > > >     This changes things to always look at the log-level in the first
> > > >     bytes of the printout. If a log level marker is found, it is always
> > > >     used as the log-level. Additionally, if no newline existed, one is
> > > >     added (unless the log-level is the explicit KERN_CONT marker, to
> > > >     explicitly show that it's a continuation of a previous line).
> > > >
> > > >
> > > >
> > 
> > Do the driver still need two dev_info at startup and shutdown since most
> > pci drivers won't print anything to system log when the driver is loaded or
> > unloaded ?
> 
> Definitely not needed, but the intention of this patch is to convert
> to dev_*().  There are some cleanups, but it's for removing redundant
> strings, so it's a bit different from changing the log level of the
> original code.  You can submit an additional patch to adjust the log
> levels more appropriately.
> 
sure , I will submit a separate patch for cleaning up these extra dev_info.

thanks
sudip
> 
> Takashi
