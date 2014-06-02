Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaFBNQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:16:08 -0400
Received: from imap.thunk.org ([74.207.234.97]:45381 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221AbaFBNQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:16:06 -0400
Date: Mon, 2 Jun 2014 09:15:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602131555.GD14276@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Arnd Bergmann <arnd@arndb.de>,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, joseph@codesourcery.com,
	john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
	geert@linux-m68k.org, lftan@altera.com,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
 <4178301.j9kWdGCRLC@wuerfel>
 <20140602115737.GB14276@thunk.org>
 <4910284.a72lauVLNV@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910284.a72lauVLNV@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:38:09PM +0200, Arnd Bergmann wrote:
> 
> "For new inodes we always reserve enough space for the kernel's known
> extended fields, but for inodes created with an old kernel this might
> not have been the case. None of the extended inode fields is critical
> for correct filesystem operation."
> 
> Do we have to worry about this for inodes that contain extended
> attributes and that get updated after 2038?

In practice, the extended timestamps was one of the first things added
to ext4, so the vast majority of ext4 file systems with inode sizes >
128 bytes will have room for the extended timestamps.  There are some
legacy ext3 file systems with 256-byte inodes (enabled for fast
sotrage of SELinux xattrs) that in theory, could have been converted
to ext4 and had enough xattrs so that the extended timestamps couldn't
be added.  That would be a vanishingly small use case, and in
practice, it's not likely to be the case for the embedded market.

I could imagine someone worrying about file systems originally
formatted using RHEL 4 post-2038 (perhaps running in a VM), but I
don't work for IBM any more, and hopefully even IBM would just tell
such customers that they need to suck it up, and do a
backup/reformat/restore pass.

Cheers,
						- Ted
