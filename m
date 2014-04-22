Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaDVO4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884AbaDVO4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:56:02 -0400
Date: Tue, 22 Apr 2014 10:55:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Frank Filz <ffilzlnx@mindspring.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] locks: rename file-private locks to "open file
 description locks"
Message-ID: <20140422105520.7b09eda5@tlielax.poochiereds.net>
In-Reply-To: <5356808B.3040303@gmail.com>
References: <1398169383-10743-1-git-send-email-jlayton@redhat.com>
	<5356808B.3040303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 17:45:31 +0300
Boaz Harrosh <openosd@gmail.com> wrote:

> On 04/22/2014 03:23 PM, Jeff Layton wrote:
> <>
> > 
> > We're going to have to live with these for a long time, so it's
> > important that we be happy with the names before we're stuck with them.
> > The consensus on the lists so far is that they should be rechristened as
> > "open file description locks".
> > 
> 
> I completely agree with the rename. (Though could you please post
> the rest of the rename patches for review)
> 
> Just a very small nit. My native language is not English but I would
> rather you use "file-descriptor" (with an '-' as well) and not
> use "description" in the English name of the lock. This is
> because stated like that, "description" might refer to the
> locks and not to the file in the sentence. file-descriptor is
> more clear I think. (For me it was confusing at first before I realized
> what you meant)
> 
> Just my $0.017
> Thanks
> 

There's a big difference between the descriptor and the description.

The numerical value you get back from something like open() is a file
descriptor. The thing that that value points to internally in the
kernel is the file description. It's very important that we do not
conflate the two here as these locks are associated with the file
description and not the file descriptor.

The best way to illustrate this is the interaction with dup() -- see
the LWN article on these for a complete overview.

-- 
Jeff Layton <jlayton@redhat.com>
