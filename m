Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaICTPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:15:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbaICTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:15:17 -0400
Date: Wed, 3 Sep 2014 12:15:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>, luca@coelho.fi,
        kvalo@adurom.com
Subject: Re: [RFC] firmware coredump: add new firmware coredump class
Message-ID: <20140903191516.GB16582@kroah.com>
References: <1409742945-3933-1-git-send-email-johannes@sipsolutions.net>
 <20140903143814.GA37365@ubuntu-hedt>
 <1409770842.911.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409770842.911.18.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:00:42PM +0200, Johannes Berg wrote:
> On Wed, 2014-09-03 at 09:38 -0500, Seth Forshee wrote:
> 
> > Overall I think this looks pretty sensible. The thing that worries me
> > though is firmware which might crash repeatedly in a short period of
> > time, resulting in a proliferation of coredumps and eating up all
> > available RAM. How about a limit of one active coredump per device or
> > something similar?
> 
> Oh, right, I completely forgot about that. Not sure what context I can
> iterate the class device list, but worst case I have to add another
> list.

Before you add another device, walk the list of all devices of the class
to see if there is already a device with the same parent.  If so, delete
that one and then continue and add the one you wanted to create.

> We likely want to store the first dump then, I suppose?

Or the last one?  I don't know...

greg k-h
