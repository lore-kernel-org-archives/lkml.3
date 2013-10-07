Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JGXOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:14:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3JGXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:14:08 -0400
Date: Mon, 7 Oct 2013 16:11:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET v2] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20131007231136.GB27270@kroah.com>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
 <20131006004032.GA3601@kroah.com>
 <20131007170005.GB2481@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007170005.GB2481@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:00:05PM -0400, Tejun Heo wrote:
> > How are you going to use sysfs from another kernel subsystem?  Is this
> > for another filesystem, or do you want to use kobjects for some other
> > subsystem that doesn't export them using sysfs?
> 
> I was at first trying to convert sysfs interface to not use kobject
> but that caused too much disruption and I'm now trying to separate out
> the core functionality into a separate filesystem - currently named
> kernfs, so sysfs will be a consumer of kernfs translating between
> kobject and kernfs interface, and cgroup will be the second user which
> replaces its own pseudo filesystem implementation with kernfs.

Ah, that would be nice, if it works out well, I might have to move
debugfs over to it also, as the current implementation of it has some
major issues.

Good luck :)

greg k-h
