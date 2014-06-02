Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaFBNH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:07:27 -0400
Received: from imap.thunk.org ([74.207.234.97]:45352 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaFBNHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:07:25 -0400
Date: Mon, 2 Jun 2014 09:07:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602130700.GC14276@thunk.org>
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
 <15496653.1vSv1RUCC0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15496653.1vSv1RUCC0@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, there are some ongoing dicussions about changing the post-2038
encoding of the timestamp in ext4, which is why this hasn't been fixed
yet.  The main thing that's been missing is time for me to review the
patches, and a good way of writing regression tests that will work (or
at least not fail) on build environments with a 32-bit time_t and
32-bit-only capable versions of functions such as gmtime(3).

And given current discussions, I may want to think about some kind of
superblock flag to allow the use of a 32-bit unsigned encoding for
file systems using a 128-byte inode, with a way of setting that flag
after scanning the file system to make sure there are no times that
are previous to January 1, 1970.  (Or more generally, allow any epoch
to be defined using a 64-bit time_t offset stored in the superblock...)

Cheers,

					- Ted
