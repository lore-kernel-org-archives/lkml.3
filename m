Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaH2S0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:26:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaH2S0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:26:48 -0400
Date: Fri, 29 Aug 2014 11:26:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen LinX <linx.z.chen@intel.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        "He, Bo" <bo.he@intel.com>
Subject: Re: [PATCH V2] debugfs: keep the old mode value at remount when no
 explicit change
Message-ID: <20140829182647.GB8631@kroah.com>
References: <1409279603-19468-1-git-send-email-linx.z.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409279603-19468-1-git-send-email-linx.z.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:33:23AM +0800, Chen LinX wrote:
> From: "Chen, LinX" <linx.z.chen@intel.com>
> 
> Android framework has a good method to detect userspace hang and reports
> UIWDT issues. It uses client/server model. Clients communicate with
> servers by binder. binder has debugfs interfaces. Some files show what
> threads are communicating with what other threads. If one thread is
> blocked for a long time, we can find the blocking chain from the binder
> info. Since the error dumping process has no root access, booting
> process changes debugfs mount dir mode to 0755. When UIWDT happens,
> the error dumping process can read the info.
> 
> Unfortunately, some other scripts at booting try to mount debugfs for
> many times. No matter if the double mounting fails or succeeds,
> debugfs_parse_options changes the root inode's mode back to default
> 0700. It means the effect of previous mode changing to 0755 is lost.
> At UIWDT, the dumping process can't save binder info to disk log files.
> 
> The patch checks if debugfs_mount_opts->mode is initiated. If it is
> already, it bypasses the reinitiation, and the old mode value is kept.

No, the default mount value for debugfs is DEBUGFS_DEFAULT_MODE, if you
wish to override that, then provide the proper mount flags when mounting
it.  Don't rely on a previous mount of the filesystem to have set it to
something else, as you never know what that might have been.

Please fix your userspace programs if you really rely on these binder
debugging files (which you really shouldn't be doing anyway, but that's
a totally different issue...)

sorry,

greg k-h
