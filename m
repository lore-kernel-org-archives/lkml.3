Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaKSOFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:05:53 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62229 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaKSOFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:05:51 -0500
Date: Wed, 19 Nov 2014 15:05:46 +0100
From: Johan Hovold <johan@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: NULL derefs after failed suspend (i915, pm, ext4, slub)
Message-ID: <20141119140546.GG7857@localhost>
References: <20141028142910.GU2006@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028142910.GU2006@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:29:10PM +0100, Johan Hovold wrote:
> Hi, 
> 
> I have had some problems with crashes involving suspend-to-disk after
> updating to v3.16.
> 
> Below is a log with 3.16.6 from a failed suspend attempt after which I
> get a NULL deref in ext4 code.
> 
> A couple of weeks ago I got something similar, with backtraces from 
> ext4 (ext4_alloc_inode) and NULL-derefs in vfs (vfs_get_attr_nosec) when
> trying to do IO after resuming from suspend. That was with 3.16.3 and I
> was hoping that whatever it was would have been fixed in 3.16.6 (there
> were some ext4 error handling patches in there). I only got photos of
> those oopses but it involved kmem_cache_alloc (slub) and a NULL-deref in
> vfs_get_attr_nosec. I can put the photos up somewhere. That time I also
> got back to X and could issue a dmesg in an xterm, but any process trying
> to do IO died.
> 
> Something similar happened with 3.16.1 but unfortunately I do not have
> any logs from that.

For the record, it seems this problem went away with 3.17 (.2 and .3).
Been suspending daily now for almost three weeks without triggering this
again.

Since 3.16 is EOL (and 3.15 did not suffer from this) I guess there's no
need to track it down for stable.

Johan
