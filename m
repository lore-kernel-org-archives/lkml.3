Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3IZXof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:44:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3IZXoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:44:34 -0400
Date: Thu, 26 Sep 2013 16:44:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, kay@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] sysfs: implement sysfs_remove()
Message-ID: <20130926234433.GA12549@kroah.com>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
 <87pps5dr3f.fsf@tw-ebiederman.twitter.com>
 <20130919123812.GA4467@mtj.dyndns.org>
 <87six0922b.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87six0922b.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:03:08PM -0500, Eric W. Biederman wrote:
> 
> I am running from memory right now.  But the short version is.
> 
> Al Viro has complained about the sysfs removal antics of sysfs, and
> I have seen Al get confused and "fix" filesystems that depart too far
> from normal filesystem semantics.
> 
> I have gone down this path both ways and "rm -rf" semantics are horrible
> and cause real bugs in the kernel at the boundaries between devices.
> "rm -rf" semantics are also horrible because no sanity checks can be
> performed.

I seem to remember some issues here as well, probably with scsi devices,
that kept us from doing this in this manner.  Can you test this on
removing some scsi devices and see if everything still works properly
with this patchset applied?

I'm really hesitant to apply this series, as it does change how sysfs
works in this area, why do you need these changes?

> I will aim to take a second look when I can spend a little more time
> and give you more concrete reasons (other than the old NAK from Viro)
> about why recursive sysfs directory removal can cause real bugs.  It is
> just subtle enough I can't remember the set of the problems in detail
> and a quick look at the code is not enough to remind me.  But I have run
> into real issues with even the limited recursive remvoval that sysfs
> does today.

What real issues did you run into?

thanks,

greg k-h
