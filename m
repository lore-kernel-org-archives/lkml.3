Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341Ab3BMR1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:27:21 -0500
Received: from awesome.dsw2k3.info ([195.71.86.230]:57149 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759726Ab3BMR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:27:18 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 12:27:18 EST
Date: Wed, 13 Feb 2013 18:16:56 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, Tilman Schmidt <tilman@imap.cc>
Subject: Re: [regression] external HDD in USB3 enclosure cannot be
 dynamically removed (Re: Linux 3.7.5)
Message-ID: <20130213171656.GA9318@citd.de>
References: <20130128045658.GA3488@kroah.com>
 <pan.2013.01.28.11.42.16.556318@googlemail.com>
 <20130128143907.GA2940@kroah.com>
 <pan.2013.01.28.20.33.44.918987@googlemail.com>
 <20130128204639.GB7759@google.com>
 <20130212004023.GA8427@xanatos>
 <511A1AF1.9080107@googlemail.com>
 <20130212204224.GC8427@xanatos>
 <511B4EB1.9010708@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <511B4EB1.9010708@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2013 09:28, Holger Hoffstätte wrote:
> On 12.02.2013 21:42, Sarah Sharp wrote:
> > [..]
> > I think I see the issue.  Your host controller reports the Inactive
> > state after a USB disconnect.  My host controllers go to the RxDetect
> > state on a disconnect.
> > 
> > The patches that went into 3.8 and the stable kernels to better handle
> > the Inactive state were not designed to handle a connected device going
> > to the Inactive state.  I thought that would be a rare case, but
> > apparently it's not.
> > 
> > There was a further set of patches queued for 3.9 to deal with connected
> > devices going to the Inactive state, but they looked like they were too
> > big for stable:
> > 
> > d3b9d7a USB: Fix connected device switch to Inactive state.
> > a24a607 USB: Rip out recursive call on warm port reset.
> > 2d4fa94 USB: Prepare for refactoring by adding extra udev checks.
> > 0fe51aa USB: Don't use EHCI port sempahore for USB 3.0 hubs.
> > 
> > Can you retry with Greg's usb-next branch?
> > 
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git -b usb-next
> > 
> > If that fixes your problem, we should either get those additional
> > patches into 3.8 and the stable trees, or do a revert of the whole
> > series and just let 3.9 carry the full patchset.
> 
> Good news! This one does indeed work as expected - the device can be
> removed and is gone for good. Upstream & Stable plz :)

That kernel fixes the problem for me too.




-- 

Matthias
