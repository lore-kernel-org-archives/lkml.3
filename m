Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaCGEAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:00:33 -0500
Received: from imap.thunk.org ([74.207.234.97]:38205 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaCGEAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:00:32 -0500
Date: Thu, 6 Mar 2014 23:00:28 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nilesh More <nilesh99999@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reporting a bug - Memory corruption in Linux kernel
Message-ID: <20140307040028.GA17965@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Nilesh More <nilesh99999@gmail.com>, linux-kernel@vger.kernel.org
References: <CAMbOQaUW7K=FBESVeo=BOXfYU6cuqthjnmMR6jmeNFnx8PcvuQ@mail.gmail.com>
 <CAMbOQaU-jX8Dvmjj_iQJGBhDesMyFj02epaROFfW+ae+BDg_tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbOQaU-jX8Dvmjj_iQJGBhDesMyFj02epaROFfW+ae+BDg_tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:39:45AM +0530, Nilesh More wrote:
> Hi all,
> 
> I am working on android bug wherein directory entries of ext4 file
> system get corrupted when USB is hotplugged (with auto mount support
> enabled).
> 
> The logs as below:
> [ 413.607849] usb 2-1.1: USB disconnect, device number 12
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Hot plugged or hot unplugged?  It looks like the problem is that the
block device disappeared out from under ext4.  Maybe you have a flaky
SD/MMC drive (i.e., funky contacts, etc.)?  Or maybe when you plug in
one USB device, the eMMC device where you have the mounted file system
disappeared?

> If I prevent kill_bdev from invalidating pages, I see a No-Repro for
> this bug. Also there are no prints saying invalid access to FAT
> entry(which were present when bug reproduces). Earlier we had no-repro
> when added delay(1) before _getblk.
> 
> This points out to the loss of sync between _getblk and kill_bdev and
> ALSO looks like kill_bdev inadvertently invalidates pages which are
> Ext4 owned.

This looks like it's much more of a hardware issue than a software
issue.  If you are plugging in a USB device, you should *not* be
getting a USB disconnect message.  And the fact that the pages being
used by ext4 are getting invalidated would be consistent with the
theory that the USB device on which the ext4 file system was on is
somehow getting disconnected, per the message in you've shown in the
logs.

						- Ted
