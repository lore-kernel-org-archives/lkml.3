Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3J3Wif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:38:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3J3Wie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:38:34 -0400
Date: Wed, 30 Oct 2013 15:38:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: move assignment to be under lock in
 sysfs_remove_dir()
Message-ID: <20131030223832.GA29216@kroah.com>
References: <20131029220939.GA23060@kroah.com>
 <8761sflhi1.fsf@tw-ebiederman.twitter.com>
 <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
 <87sivj9vi0.fsf@xmission.com>
 <20131030132831.GB27632@htj.dyndns.org>
 <8738ni308z.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738ni308z.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:41:16PM -0700, Eric W. Biederman wrote:
> One of the particularly problematic things that can happen with sysfs is
> that we can get a hotplug event in userspace and then examine sysfs and
> not find the attributes of the device because the kernel has not added
> them yet.
> 
> Which is a particularly good reason to have a campaign against
> independent usage of device_create_file and device_remove_file in the
> device users.

I have been working on that over the past few months, there are now
default attribute groups for all things, and those are used to create
the files _before_ the hotplug event goes to userspace.  I still have
more work to do to clean this up, but my goal is to remove
device_create_file() entirely, although we still have some work to go
for the platform driver case, which will take some time.

But we will get there eventually, it's a problem that has to be fixed as
more and more people hit this with multi-core, fast systems these days.

> At which point really the right thing to do when we delete a directory
> is to WARN and be very grumpy if there are any attributes in the
> directory we were removing.

We tried this once, and it was a mess.  But that was a long time ago,
maybe it's better now, I'll look and see...

thanks,

greg k-h
