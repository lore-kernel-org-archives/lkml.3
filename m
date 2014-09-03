Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaICTV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:21:27 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:34551 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbaICTV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:21:26 -0400
Message-ID: <1409772081.911.30.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC] firmware coredump: add new firmware coredump class
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>, luca@coelho.fi,
        kvalo@adurom.com
Date: Wed, 03 Sep 2014 21:21:21 +0200
In-Reply-To: <20140903191516.GB16582@kroah.com>
References: <1409742945-3933-1-git-send-email-johannes@sipsolutions.net>
	 <20140903143814.GA37365@ubuntu-hedt>
	 <1409770842.911.18.camel@jlt4.sipsolutions.net>
	 <20140903191516.GB16582@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 12:15 -0700, Greg Kroah-Hartman wrote:
> On Wed, Sep 03, 2014 at 09:00:42PM +0200, Johannes Berg wrote:
> > On Wed, 2014-09-03 at 09:38 -0500, Seth Forshee wrote:
> > 
> > > Overall I think this looks pretty sensible. The thing that worries me
> > > though is firmware which might crash repeatedly in a short period of
> > > time, resulting in a proliferation of coredumps and eating up all
> > > available RAM. How about a limit of one active coredump per device or
> > > something similar?
> > 
> > Oh, right, I completely forgot about that. Not sure what context I can
> > iterate the class device list, but worst case I have to add another
> > list.
> 
> Before you add another device, walk the list of all devices of the class
> to see if there is already a device with the same parent.  If so, delete
> that one and then continue and add the one you wanted to create.

Or throw away the new data, yeah. The "context" part was just that I was
aiming to make this function callable say without being able to sleep
(hence also the gfp_t argument) but I don't know for sure I can iterate
the class device list that way. I can look it up though - no need for
anyone else to answer that question :)

> > We likely want to store the first dump then, I suppose?
> 
> Or the last one?  I don't know...

It might even have to be device-specific policy? But in general I'd
think that the first would make more sense because mostly we'd try to
recover from the issue, but if that results in another issue that's
usually not all that helpful to know about.

johannes

