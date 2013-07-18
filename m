Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab3GRAPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:15:22 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38116 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab3GRAPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:15:20 -0400
Date: Wed, 17 Jul 2013 17:15:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>, Jeff Layton <jlayton@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Jim Cromie <jim.cromie@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 0/5] initmpfs v2: use tmpfs instead of ramfs for rootfs
In-Reply-To: <20130717160602.4b225ac80b1cb6121cbb489c@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1307171706050.4294@eggly.anvils>
References: <20130715140135.0f896a584fec9f7861049b64@linux-foundation.org> <20130717160602.4b225ac80b1cb6121cbb489c@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Andrew Morton wrote:
> On Tue, 16 Jul 2013 08:31:13 -0700 (PDT) Rob Landley <rob@landley.net> wrote:
> 
> > Use tmpfs for rootfs when CONFIG_TMPFS=y and there's no root=.
> > Specify rootfstype=ramfs to get the old initramfs behavior.
> > 
> > The previous initramfs code provided a fairly crappy root filesystem:
> > didn't let you --bind mount directories out of it, reported zero
> > size/usage so it didn't show up in "df" and couldn't run things like
> > rpm that query available space before proceeding, would fill up all
> > available memory and panic the system if you wrote too much to it...
> 
> The df problem and the mount --bind thing are ramfs issues, are they
> not?  Can we fix them?  If so, that's a less intrusive change, and we
> also get a fixed ramfs.

I'll leave others to comment on "mount --bind", but with regard to "df":
yes, we could enhance ramfs with accounting such as tmpfs has, to allow
it to support non-0 "df".  We could have done so years ago; but have
always preferred to leave ramfs as minimal, than import tmpfs features
into it one by one.

I prefer Rob's approach of making tmpfs usable for rootfs.

Hugh
