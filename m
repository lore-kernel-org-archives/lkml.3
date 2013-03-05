Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3CEWL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:11:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:6954 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3CEWL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:11:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="299573698"
Date: Tue, 5 Mar 2013 14:10:50 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: Matthias Schniedermeyer <ms@citd.de>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Tilman Schmidt <tilman@imap.cc>,
        kernel-team@lists.ubuntu.com,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Stable backport request, Was: Re: [regression] external HDD in USB3
 enclosure cannot be dynamically removed (Re: Linux 3.7.5)
Message-ID: <20130305221050.GC8339@xanatos>
References: <511A1AF1.9080107@googlemail.com>
 <20130212204224.GC8427@xanatos>
 <511B4EB1.9010708@googlemail.com>
 <20130213171656.GA9318@citd.de>
 <20130213193303.GH8427@xanatos>
 <20130213200413.GA17648@citd.de>
 <20130213210846.GI8427@xanatos>
 <20130213213129.GA10288@kroah.com>
 <20130213221250.GJ8427@xanatos>
 <20130301164839.GA5435@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301164839.GA5435@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 08:48:39AM -0800, Greg KH wrote:
> On Wed, Feb 13, 2013 at 02:12:50PM -0800, Sarah Sharp wrote:
> > On Wed, Feb 13, 2013 at 01:31:29PM -0800, Greg KH wrote:
> > > On Wed, Feb 13, 2013 at 01:08:46PM -0800, Sarah Sharp wrote:
> > > > On Wed, Feb 13, 2013 at 09:04:13PM +0100, Matthias Schniedermeyer wrote:
> > > > > On 13.02.2013 11:33, Sarah Sharp wrote:
> > > > Greg,
> > > > 
> > > > How do you want to handle this?  The above four patches should go into
> > > > 3.8 and stable, but they're not currently in Linus' tree and it's
> > > > probably too late in the cycle to merge them this week.  Should we just
> > > > wait until 3.9 is out and put the patches into the stable trees then?
> > > 
> > > > My email shows that the bad commit
> > > > f7965c0846d74b270e246c1470ca955d5078eb07 has been added to the 3.2, 3.4,
> > > > and 3.7 stable trees, as well as Canonical's 3.7 stable tree.  I'm also
> > > > fine with just reverting that commit from 3.8 and stable.
> > > 
> > > It's probably easier at this point in time to just revert that commit,
> > > leave the stable kernels alone, and then everything will be fixed in
> > > 3.9.  When the commits go into Linus's tree, we can backport everything
> > > to the stable releases (including 3.8.1) at that point.
> > > 
> > > As long as someone remembers to send the needed information to
> > > stable@vger.kernel.org, I know I'll forget :)
> > > 
> > > Sound ok?
> > 
> > Yep, sounds fine.  I'll attempt to remember to send email to stable once
> > 3.9 is out.
> 
> Did this happen yet?

Nope.  Here's the upstream commit IDs of the patches that need to be
backported to stable.  Let me know if you need them in patch form:

d3b9d7a9051d7024a93c76a84b2f84b3b66ad6d5 USB: Fix connected device switch to Inactive state.
a24a6078754f28528bc91e7e7b3e6ae86bd936d8 USB: Rip out recursive call on warm port reset.
2d4fa940f99663c82ba55b2244638833b388e4e2 USB: Prepare for refactoring by adding extra udev checks.
0fe51aa5eee51db7c7ecd201d42a977ad79c58b6 USB: Don't use EHCI port sempahore for USB 3.0 hubs.

Sarah Sharp
