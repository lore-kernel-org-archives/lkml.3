Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab3APIWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:22:05 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40148 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3APIWD (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 16 Jan 2013 03:22:03 -0500
Date: Wed, 16 Jan 2013 16:21:09 +0800
From: Guangliang Zhao <gzhao@suse.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, mpatocka@redhat.com
Cc: agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3 v3] add resync speed control for dm-raid1
Message-ID: <20130116082109.GA2154@glzhao-laptop.site>
Mail-Followup-To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	mpatocka@redhat.com, agk@redhat.com
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
 <Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 12:43:21AM -0500, Mikulas Patocka wrote:
> Hi
Hi,

I think it is very good that your patches could be used for other
targets(snapshot, thin) after reviewing yours, but I find some issues
(maybe not, please correct me if I am wrong).

> 
> I did this already some times ago.
> I'm sending my patches in the next mail.
> 
> Basically, my and Guangliang's patches have the following differences:
> 
> my patch: uses per-module throttle settings
> Guangliang's patch: uses per-device settings
> (my patch could be changed to use per-device throttle too, but without 
> userspace support it isn't much useful because userspace lvm can 
> reload the mirror and per-device settings would be lost)

We couldn't force every devices in the system hold the same throttle,
IMHO, per-device settings couldn't be ignored. 
Setting the global value by the parameters of module is a good way, and
it could also be used to set the default value in my patches. In this way,
the global setting wouldn't be lost, and we could also adjust every device's
speed.

> 
> my patch: uses fine grained throttling of the individual IOs in kcopyd - 
> it measures active/inactive ratio and if the disk is active more than the 
> specified percentage of time, sleep is inserted.

I think this policy might not be able to represent the exact write speed, 
while other modules(such as md, drbd) monitor the real IO speed.

> Guangliang's patch: throttles on segment granularity, it waits when 
> starting new segment, but segment is copied unthrottled.
> 
> my patch: the user selects a percentage value (0 - 100) in 
> "/sys/module/dm_mirror/parameters/raid1_resync_throttle", the device is 
> kept active the specified percent of time
> Guangliang's patch: limits the number of segments per a specified 
> interval
> 
> My patch is noticeably bigger.
> 
> Mikulas
> 
> 
> On Mon, 7 Jan 2013, Guangliang Zhao wrote:
> 
> > Hi,
> > 
> > These patches are used to add resync speed control for dm-raid1. The
> > second and third patch provide support for user-space tool dmsetup.
> > I have made some modifications by the comments. This is the third
> > version.
> > 
> > Guangliang Zhao (3):
> >   dm raid1: add resync speed control for dm-raid1
> >   dm raid1: add interface to set resync speed
> >   dm raid1: add interface to get resync speed
> > 
> >  drivers/md/dm-raid1.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 89 insertions(+), 1 deletion(-)
> > 
> > -- 
> > 1.7.10.4
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 

-- 
Best regards,
Guangliang
