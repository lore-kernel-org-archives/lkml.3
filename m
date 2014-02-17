Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaBQSE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:04:28 -0500
Received: from imap.thunk.org ([74.207.234.97]:59083 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbaBQSEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:04:24 -0500
Date: Mon, 17 Feb 2014 13:04:08 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140217180408.GB16660@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, bfields@fieldses.org,
	hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
	zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <20140210105145.GW13997@dastard>
 <20140211160141.GD8204@tucsk.piliscsaba.szeredi.hu>
 <20140212171852.GA4026@tucsk.piliscsaba.szeredi.hu>
 <20140217081911.GZ13647@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217081911.GZ13647@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 07:19:11PM +1100, Dave Chinner wrote:
> [ FWIW, the normal way to write an xfstest like this is to write a
> small helper program that just does the renameat2() syscall (we
> often use xfs_io to provide this) and everything is just shell
> scripts to drive the helper program in the necessary way. We don't
> directly check that mode, size, destination of a file is correct -
> just stat(1) on the expected destinations is sufficient to capture
> this information. stdout is captured by the test harness and used to match
> against a golden output. If the match fails, the test fails.

The other reason why it's really nice to use a small helper program is
that it becomes much easier for file system developers to debug kernel
problems without having to create their own single-shot C programs.

It also becomes easier to debug a test failure by looking at the shell
script and manually running the commands one at a time, perhaps
changing some of the arguments after getting an xfstest failure from
inside a VM running a test kernel, since the VM very often won't even
have a C compiler.

It also becomes easier to add new test just simply by updating the
shell script, which is another win.

> And finally, it needs comments to explain what the test is actually
> testing - if you don't document what the test is supposed to be
> checking, how do we know that it is testing is actually correct?

Yes, please!

					- Ted
