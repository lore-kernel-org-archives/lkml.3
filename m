Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaH2SYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:24:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaH2SYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:24:34 -0400
Date: Fri, 29 Aug 2014 11:24:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Chen LinX <linx.z.chen@intel.com>, linux-kernel@vger.kernel.org,
        "He, Bo" <bo.he@intel.com>
Subject: Re: [PATCH] debugfs: keep the old valid mode value when no explicity
 specify it
Message-ID: <20140829182433.GA8631@kroah.com>
References: <1409220549-15485-1-git-send-email-linx.z.chen@intel.com>
 <20140828151020.GA17945@kroah.com>
 <53FFD7CE.5050000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FFD7CE.5050000@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 09:30:54AM +0800, Zhang, Yanmin wrote:
> On 2014/8/28 23:10, Greg KH wrote:
> 
> >On Thu, Aug 28, 2014 at 06:09:09PM +0800, Chen LinX wrote:
> >>From: "Chen, LinX" <linx.z.chen@intel.com>
> >>
> >>When mount debugfs with no mode specifed after it's mounted, the mount
> >>point mode will change to default mode(0700) even the mount operation was fail,
> >>this will cause some issues like can't get binder info in android.
> >I don't understand, what did you do to get into this state?
> 
> Greg,
> 
> Thanks for your kind quick comments. The patch description can be improved.
> 
> We hit the issue when debugging a UIWDT issue. Android framework has a good
> method to detect userspace hang and reports UIWDT issues. Android uses
> client/server model. Clients communicates with servers by binder. binder has
> debugfs interfaces. Some files show what threads are communicating with what
> other threads. If one thread is blocked for a long time, we can find the
> blocking chain from the binder info.
> 
> Since the error dumping process has no root access, booting process changes
> debugfs mount dir mode to 0755. When UIWDT happens, the error dumping
> process can read the info.
> 
> Unfortunately, some other scripts at booting try to mount debugfs for many times.
> No matter if the double mounting fails or succeeds, debugfs_parse_options changes
> the root inode's mode back to the default 0700. It means the effect of previous
> mode changing to 0755 is lost. At UIWDT, the dumping process can't save binder
> info to disk log files.

Then fix those other scripts, don't try to work around broken userspace
scripts by changing the kernel.

Sorry, I can't take this patch.

greg k-h
