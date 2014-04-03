Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaDCTNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:13:16 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:65018 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaDCTNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:13:13 -0400
Date: Thu, 3 Apr 2014 15:13:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Dave Reisner <d@falconindy.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, thomas@archlinux.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com
Subject: Re: Initramfs FSID altered in 3.14
Message-ID: <20140403191307.GA2472@mtj.dyndns.org>
References: <20140403175744.GE585@rampage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403175744.GE585@rampage>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Thu, Apr 03, 2014 at 01:57:44PM -0400, Dave Reisner wrote:
> With Linux 3.14, you might notice in /proc/self/mountinfo that your
> root's parent FSID is now 0, instead of the 1 that it's been for the
> last N years. Tejun wrote the change (9e30cc9595303b27b48) that caused
> this, but the change comes in a rather innocuous way. Instead of an
> internal kernel mount of sysfs being assigned 0, it's now the initramfs.
> 
> So far, this has already caused switch_root and findmnt (from
> util-linux) to break, cp (from coreutils) to break when using the -x
> flag in early userspace, and it's also been pointed out that systemd's
> readahead code makes assumptions about a device number of 0.
> 
> Are we now supposed to go and change all the assumptions in userspace
> about 0 being special? I'm conflicted. The kernel isn't supposed to
> break userspace, but it seems to me that FSIDs were never something to
> rely on -- similar to the block device numbering scheme.

I think this is the same problem Alexandre Demers reported.  Arch was
failing to boot with the commit.  There's already a patch pending to
reinstate the internal mount but I think what Thomas is proposing -
just starting allocating FSID from 1 is a better solution.  Alexandre,
can you please test Thomas' patch?

Thanks.

-- 
tejun
