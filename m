Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaEODFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:05:13 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26228 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbaEODFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:05:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgpIADMudFN5LL1sPGdsb2JhbABZDoJ4gz6FCqQDAQEBAQEBBpodAYEaFwMBAQEBODWCJQEBBTocMwgDGAklDwUlAwcaARKIQNFOFxaFPogsVYRAAQOZUJYLUiuBMSM
Date: Thu, 15 May 2014 13:04:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Mateusz Guzik <mguzik@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515030404.GV26353@dastard>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <20140514215457.GC5421@dastard>
 <20140515021749.GA3123@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515021749.GA3123@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 10:17:49PM -0400, Theodore Ts'o wrote:
> On Thu, May 15, 2014 at 07:54:57AM +1000, Dave Chinner wrote:
> > On Tue, May 13, 2014 at 08:31:02PM +0200, Mateusz Guzik wrote:
> > > This helps hang troubleshooting efforts when only dmesg is available.
> > 
> > I really don't think that spamming dmesg every time a filesystem is
> > frozen or thawed is a good idea. This happens a *lot* when systems
> > are using snapshots, and for the most part nobody cares about
> > freeze/thaw cycles because they almost always work just fine.
> 
> The problems people are worried about are when there is freezing and
> unfreezing taking place in combination with a machine-level
> suspend/resume cycle, no?  What if we only spammed dmesg when doing a
> suspend/resume?

Filesystems are not frozen by power management based suspend/resume
cycles. That uses sync and then assumes that it can't race with
with the filesystem doing metadata writeback while the suspend code
is creating the freeze image. Hence there won't by any syslog
spam because freeze is not used. ;)

Sure, I've been advocating that suspend should use freezing rather
than sync for years, but that's never happened...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
