Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616AbaDJOuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:50:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56848 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933057AbaDJOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:50:00 -0400
X-Sasl-enc: yKUi7g204b+UmDOpBTFBGJ7GaQuJuwuwh09pOjder+Hl 1397141396
Date: Thu, 10 Apr 2014 14:45:48 +0000
From: Colin Walters <walters@verbum.org>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
To: tytso@mit.edu
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>, Kristian@thunk.org,
        john.stultz@linaro.org, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>, mtk.manpages@gmail.com
Message-Id: <1397141388.16343.10@mail.messagingengine.com>
In-Reply-To: <20140320153250.GC20618@thunk.org>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<20140320153250.GC20618@thunk.org>
X-Mailer: geary/0.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
X-OriginalDate: Thu, 10 Apr 2014 14:45:48 -0004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:32 AM, tytso@mit.edu wrote:
> 
> Looking at your patches, and what files you are modifying, you are
> enforcing this in the low-level file system.

I would love for this to be implemented in the filesystem level as 
well.  Something like the ext4 immutable bit, but with the ability to 
still make hardlinks would be *very* useful for OSTree.  And anyone 
else that uses hardlinks as a data source.  The vserver people do 
something similiar:
http://linux-vserver.org/util-vserver:Vhashify

At the moment I have a read-only bind mount over /usr, but what I 
really want is to make the individual objects in the object store in 
/ostree/repo/objects be immutable, so even if a user or app navigates 
out to /sysroot they still can't mutate them (or the link targets in 
the visible /usr).




