Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaENWBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:01:08 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58487 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaENWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:01:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgpIADHnc1N5LL1sPGdsb2JhbABZgwaDPoUKpCQBAQEBAQEGmh0BgScXAwEBAQE4NYIlAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQNFeFxaFPoh6B4MrgRUEmVCWXSs
Date: Thu, 15 May 2014 08:00:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140514220052.GD5421@dastard>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
 <1400018683-5565-2-git-send-email-mguzik@redhat.com>
 <20140514111449.GB5824@quack.suse.cz>
 <20140514112619.GA10637@mguzik.redhat.com>
 <20140514113945.GC5824@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514113945.GC5824@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:39:45PM +0200, Jan Kara wrote:
> On Wed 14-05-14 13:26:21, Mateusz Guzik wrote:
> > On Wed, May 14, 2014 at 01:14:49PM +0200, Jan Kara wrote:
> > > On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
> > > > This helps hang troubleshooting efforts when only dmesg is available.
> > > > 
> > > > While here remove code duplication with MS_RDONLY case and fix a
> > > > whitespace nit.
> > >   I'm somewhat undecided here I have to say. On one hand I don't like
> > > printing to kernel log when everything is fine and kernel is operating
> > > normally. On the other hand I've seen quite a few cases where people have
> > > shot themselves in the foot with filesystem freezing so having some trace
> > > of this in the log doesn't seem like a completely bad thing either. What do
> > > other people think?
> > > 
> > 
> > I would like to note that the kernel already prints messages when e.g.
> > filesystems get mounted.
>   Yeah, that's a fair point.

But filesystems choose to output that info, not the VFS. When you do
a remount,ro there is no output in syslog, because filesystems don't
need to dump any output - the state change is reflected in
/proc/self/mounts. IMO frozen should state should be communicated
the same way so that it is silent when it just works, and the state
can easily be determined when something goes wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
