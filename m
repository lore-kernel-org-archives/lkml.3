Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3KVHjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:39:14 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:51651 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3KVHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:39:10 -0500
Date: Fri, 22 Nov 2013 08:38:54 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: linux-mm@kvack.org, Seth Jennings <sjennings@variantweb.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Subject: Re: [PATCH] mm/zswap: change params from hidden to ro
Message-ID: <20131122073851.GB1853@hp530>
References: <1384965522-5788-1-git-send-email-ddstreet@ieee.org>
 <20131120173347.GA2369@hp530>
 <CALZtONA81=R4abFMpMMtDZKQe0s-8+JxvEfZO3NEZ910VwRDmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <CALZtONA81=R4abFMpMMtDZKQe0s-8+JxvEfZO3NEZ910VwRDmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:52:47PM -0500, Dan Streetman wrote: > On Wed, Nov
20, 2013 at 12:33 PM, Vladimir Murzin <murzin.v@gmail.com> wrote: > > Hi Dan!
> >
> > On Wed, Nov 20, 2013 at 11:38:42AM -0500, Dan Streetman wrote:
> >> The "compressor" and "enabled" params are currently hidden,
> >> this changes them to read-only, so userspace can tell if
> >> zswap is enabled or not and see what compressor is in use.
> >
> > Could you elaborate more why this pice of information is necessary for
> > userspace?
> 
> For anyone interested in zswap, it's handy to be able to tell if it's
> enabled or not ;-)  Technically people can check to see if the zswap
> debug files are in /sys/kernel/debug/zswap, but I think the actual
> "enabled" param is more obvious.  And the compressor param is really
> the only way anyone from userspace can see what compressor's being
> used; that's helpful to know for anyone that might want to be using a
> non-default compressor.

So, it is needed for user not userspace? I tend to think that users are smart
enough to check cmdline for that. 

AFAICS module_param exist here to provide simplest ability to handle the
setting via cmdline. zsawap is not able to be loaded as a module for now. If
it could, than there was reason to check which params were used while module
loading and guess how they affected zswap state. 

> 
> And of course, eventually we'll want to make the params writable, so
> the compressor can be changed dynamically, and zswap can be enabled or
> disabled dynamically (or at least enabled after boot).

module_params is not the best place to handle this, because they do not
provide any hooks for handling write unless I missed something. However,
making zswap state dynamically adjustable require not only setting the
numbers, but handling the correctness switching from one state to another.

Vladimir
