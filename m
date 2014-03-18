Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaCRPOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:14:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:43057 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbaCRPOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:14:01 -0400
Date: Tue, 18 Mar 2014 11:13:38 -0400
From: tytso@mit.edu
To: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Q on ioctl BLKGETSIZE
Message-ID: <20140318151338.GA8506@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	"Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>,
	<linux-kernel@vger.kernel.org>
References: <53284765020000A100014E30@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53284765020000A100014E30@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 01:17:25PM +0100, Ulrich Windl wrote:
> 
> Three questions:
> 1) Shouldn't the manual page says that the sector size of always 512 Bytes, even on new disks with larger sectors?
> 2) Should the real sector size be used for new disks?

The HDD industry is using 512 byte logical sectors (so LBA's are in
units of 512 byte sectors), even for disks with a physical sector size
of 4k (and in the next 4-5 years, they would like to go to 32k
physical sector sizes).

> 3) When using 512-bytes sector size, isn't the capacity limited to 2TB (2^31 kB)?

Yes.  That's why we have the BLKGETSIZE64 ioctl.

Example code:

https://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/tree/lib/ext2fs/getsize.c

						- Ted
