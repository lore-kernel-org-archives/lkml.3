Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbaD1VlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:41:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:38206 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040AbaD1VlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:41:15 -0400
Date: Mon, 28 Apr 2014 17:41:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: Add "initialized" variable to proc
Message-ID: <20140428214112.GC7857@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:52:11PM +0200, Florian Weimer wrote:
> Before this change, you had to check kernel log messages to see if the
> non-blocking pool had been properly initialized.  With this change, you
> can consult the file /proc/sys/kernel/random/intialized instead.
> 
> Signed-off-by: Florian Weimer <fweimer@redhat.com>

The main reason why I hadn't added a facility like this was because
the main goal was to make knowledge of when the /dev/urandom entropy
pool had been fully initialized could be made clear.  In fact, at
least on my laptop, this happened at 2.5 seconds after boot, which is
after the hard drives had been probed, and before all of the various
laptop devices have been fully probed.

My goal was to see if we could make it be more or less guaranteed that
by the time userspace daemons started coming up, in practice
/dev/urandom would be initialized, so we wouldn't have to change
userspace.  And for the most part, this isn't a problem.

Now there may be systems where the device probe can happen much more
quickly. in which case it does make sense for really paranoid crypto
libraries to check if the urandom pool has been fully initialized.
But in that case, instead of (or perhaps in addition to) providing a
file which a library daemon could poll on, to provide an ioctl
interface which allows userspace to block until /dev/urandom has been
initialized.

						- Ted
