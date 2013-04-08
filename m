Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935621Ab3DHTUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:20:31 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:54867 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113Ab3DHTU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:20:29 -0400
Date: Mon, 8 Apr 2013 12:20:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, bsingharora@gmail.com,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter@redhat.com,
        linux-kernel@vger.kernel.org, dhaval.giani@gmail.com,
        workman-devel@redhat.com
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130408192024.GL3021@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130408175925.GE28292@redhat.com>
 <20130408181607.GI3021@htj.dyndns.org>
 <20130408191105.GG28292@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408191105.GG28292@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 08, 2013 at 03:11:05PM -0400, Vivek Goyal wrote:
> >  What if the program crashes?
> 
> I am not sure about this. I guess when applications comes back after crash,
> it can go through all the children cgroups and reclaim empty cgroups.

Fragile, right?  What are you arguing here?

> >  Wouldn't it make more sense to just have
> > a central arbitrator that everyone talks to?
> 
> May be. Just that in the past folks have not liked the idea of talking
> to central authority to figure out resource group of an object they are
> managing.

What we've been doing seems tragically broken to me, so I'm not sure
"people didn't use to do it that way" is a good point.

> >  What's the benefit of
> > distributing the responsiblities here?  It's not like we can put them
> > in different security domains.
> 
> To me it makes sense in a way, as these resources associated with the
> service is just one another property and there does not seem to be
> anything special about this property that it should be managed using
> a single centralized authority.
> 
> For example, one might want to say that maximum IO bandwidth for 
> virtual machine virt1 on disk sda should be 10MB/s. Now libvirt
> should be able to save it in virtual machine specific configuration
> easily and whenever virtual machine is started, create a children
> cgroup, set the limits as specified.

Yes, sure, libvirt can *request* whatever it seems appropriate to the
central authority, which will decide whether it'll be able to honor
the request and grant it if possible and allowed by policies in
effect.

> That would make sense. systemd had this conflict with cgconfig
> too. Problem is that systemd starts first and sets up everything. Now
> if there is a service which sets up cgroups, after systemd startup,
> it is already late.

Come on, that's not a difficult or fundamental problem.  Whatever the
central authority may be, systemd can use it to setup the initial
hierarchy or set up bare-bone hierarchy in compatible manner.  This
isn't that different from udev.

Thanks.

-- 
tejun
