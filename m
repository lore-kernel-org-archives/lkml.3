Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab3BMVIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:08:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:7113 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3BMVIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:08:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,658,1355126400"; 
   d="scan'208";a="285364692"
Date: Wed, 13 Feb 2013 13:08:46 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Matthias Schniedermeyer <ms@citd.de>, Greg KH <gregkh@linuxfoundation.org>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Tilman Schmidt <tilman@imap.cc>, kernel-team@lists.ubuntu.com,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [regression] external HDD in USB3 enclosure cannot be
 dynamically removed (Re: Linux 3.7.5)
Message-ID: <20130213210846.GI8427@xanatos>
References: <20130128143907.GA2940@kroah.com>
 <pan.2013.01.28.20.33.44.918987@googlemail.com>
 <20130128204639.GB7759@google.com>
 <20130212004023.GA8427@xanatos>
 <511A1AF1.9080107@googlemail.com>
 <20130212204224.GC8427@xanatos>
 <511B4EB1.9010708@googlemail.com>
 <20130213171656.GA9318@citd.de>
 <20130213193303.GH8427@xanatos>
 <20130213200413.GA17648@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130213200413.GA17648@citd.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:04:13PM +0100, Matthias Schniedermeyer wrote:
> On 13.02.2013 11:33, Sarah Sharp wrote:
> > On Wed, Feb 13, 2013 at 06:16:56PM +0100, Matthias Schniedermeyer wrote:
> > > On 13.02.2013 09:28, Holger Hoffstätte wrote:
> > > > On 12.02.2013 21:42, Sarah Sharp wrote:
> > > > > [..]
> > > > > There was a further set of patches queued for 3.9 to deal with connected
> > > > > devices going to the Inactive state, but they looked like they were too
> > > > > big for stable:
> > > > > 
> > > > > d3b9d7a USB: Fix connected device switch to Inactive state.
> > > > > a24a607 USB: Rip out recursive call on warm port reset.
> > > > > 2d4fa94 USB: Prepare for refactoring by adding extra udev checks.
> > > > > 0fe51aa USB: Don't use EHCI port sempahore for USB 3.0 hubs.
> > 
> > Holger and Matthias, can you double check that cherry picking just those
> > four patches on top of 3.7.7 or 3.8 works as well?
> 
> 3.7.7 + those 4 patches workes for me.
> 
> As i'm not very firm in git i generated separate diffs for each commit 
> and applying them in the order 2d4fa94 0fe51aa d3b9d7a a24a607 worked 
> without hunks dropped.
> 
> I have attached `git diff` against vanilla 3.7.7, so you can check that 
> i got it right.

Yep, that diff looks fine compared to the git diff of those four patches.

Greg,

How do you want to handle this?  The above four patches should go into
3.8 and stable, but they're not currently in Linus' tree and it's
probably too late in the cycle to merge them this week.  Should we just
wait until 3.9 is out and put the patches into the stable trees then?

My email shows that the bad commit
f7965c0846d74b270e246c1470ca955d5078eb07 has been added to the 3.2, 3.4,
and 3.7 stable trees, as well as Canonical's 3.7 stable tree.  I'm also
fine with just reverting that commit from 3.8 and stable.

Sarah Sharp
