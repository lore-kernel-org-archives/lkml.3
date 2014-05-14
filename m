Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaENVzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:55:01 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58125 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaENVzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:55:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgpIAOPkc1N5LL1sPGdsb2JhbABZgwaDPoUKpCQBAQEBAQEGmh0BgScXAwEBAQE4NYIlAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQNFYFxaFPoh6B4MrgRUBA5lQll0rgTEk
Date: Thu, 15 May 2014 07:54:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140514215457.GC5421@dastard>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400005862-3751-2-git-send-email-mguzik@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 08:31:02PM +0200, Mateusz Guzik wrote:
> This helps hang troubleshooting efforts when only dmesg is available.

I really don't think that spamming dmesg every time a filesystem is
frozen or thawed is a good idea. This happens a *lot* when systems
are using snapshots, and for the most part nobody cares about
freeze/thaw cycles because they almost always work just fine.

I'd think that /proc/self/mounts would be a much better place to
indicate that the fs is frozen. After all, that's where we tell
people whether the filesystem is ro or rw, and frozen is just
a temporary, non-invasive ro state...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
