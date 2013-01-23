Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3AWBor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:44:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3AWBop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:44:45 -0500
Date: Tue, 22 Jan 2013 20:44:41 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Guangliang Zhao <gzhao@suse.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3 v3] add resync speed control for dm-raid1
In-Reply-To: <20130116082109.GA2154@glzhao-laptop.site>
Message-ID: <Pine.LNX.4.64.1301222033290.4723@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
 <Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
 <20130116082109.GA2154@glzhao-laptop.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2013, Guangliang Zhao wrote:

> On Wed, Jan 09, 2013 at 12:43:21AM -0500, Mikulas Patocka wrote:
> > Hi
> Hi,
> 
> I think it is very good that your patches could be used for other
> targets(snapshot, thin) after reviewing yours, but I find some issues
> (maybe not, please correct me if I am wrong).
> 
> > 
> > I did this already some times ago.
> > I'm sending my patches in the next mail.
> > 
> > Basically, my and Guangliang's patches have the following differences:
> > 
> > my patch: uses per-module throttle settings
> > Guangliang's patch: uses per-device settings
> > (my patch could be changed to use per-device throttle too, but without 
> > userspace support it isn't much useful because userspace lvm can 
> > reload the mirror and per-device settings would be lost)
> 
> We couldn't force every devices in the system hold the same throttle,
> IMHO, per-device settings couldn't be ignored. 
> Setting the global value by the parameters of module is a good way, and
> it could also be used to set the default value in my patches. In this way,
> the global setting wouldn't be lost, and we could also adjust every device's
> speed.

It could be good to have per-device throttle.

> > my patch: uses fine grained throttling of the individual IOs in kcopyd - 
> > it measures active/inactive ratio and if the disk is active more than the 
> > specified percentage of time, sleep is inserted.
> 
> I think this policy might not be able to represent the exact write speed, 
> while other modules(such as md, drbd) monitor the real IO speed.

But you don't want to limit raid resynchronization to a certain speed. A 
disk has varying speed, it is faster in the beginning and slower in the 
end.

So if you want to limit raid resynchronization so that other tasks have 
faster access to the disk, you need to limit percentage of time that is 
spent on resynchronization, not resynchronization speed.

Mikulas
