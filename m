Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3JGRAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:00:12 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57037 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3JGRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:00:10 -0400
Date: Mon, 7 Oct 2013 13:00:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET v2] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20131007170005.GB2481@htj.dyndns.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
 <20131006004032.GA3601@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006004032.GA3601@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Oct 05, 2013 at 05:40:32PM -0700, Greg KH wrote:
> > * 0001-0008 are the same as before.
> 
> Nice, I've applied all of these now.

Great!

> How are you going to use sysfs from another kernel subsystem?  Is this
> for another filesystem, or do you want to use kobjects for some other
> subsystem that doesn't export them using sysfs?

I was at first trying to convert sysfs interface to not use kobject
but that caused too much disruption and I'm now trying to separate out
the core functionality into a separate filesystem - currently named
kernfs, so sysfs will be a consumer of kernfs translating between
kobject and kernfs interface, and cgroup will be the second user which
replaces its own pseudo filesystem implementation with kernfs.

Thanks a lot.

-- 
tejun
