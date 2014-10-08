Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaJHLJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:09:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:43456 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHLI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:08:58 -0400
Date: Wed, 8 Oct 2014 15:08:30 +0400
From: Andrew Vagin <avagin@parallels.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrey Vagin <avagin@openvz.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        Andrey Vagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Message-ID: <20141008110829.GC24908@paralelels.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <87mw97wqvx.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <87mw97wqvx.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:45:22PM -0700, Eric W. Biederman wrote:
> Andrey Vagin <avagin@openvz.org> writes:
> 
> > From: Andrey Vagin <avagin@gmail.com>
> >
> > Currently when we create a new container with a separate root,
> > we need to clone the current mount namespace with all mounts and then
> > clean up it by using pivot_root(). A big part of mountpoints are cloned
> > only to be umounted.
> 
> Is the motivation performance?  Because if that is the motivation we
> need numbers.

The major motivation to create a clean mount namespace which contains
only required mounts.

Now you want to convince us that there is nothing wrong if we use
userns, because all inherited mounts are locked. My point is that all
useless mounts should be umounted.  If the current root isn't on rootfs,
pivot_root() allows us to umount all useless points. But pivot_root()
doesn't work, if the current root is on rootfs. How can we umount
useless points in this case?

Maybe we want to say that rootfs should not be used if we are going to
create containers...

Thanks,
Andrew

