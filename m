Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbaDJUdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:33:11 -0400
Received: from imap.thunk.org ([74.207.234.97]:52639 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbaDJUdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:33:05 -0400
Date: Thu, 10 Apr 2014 16:32:46 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
Message-ID: <20140410203246.GB31614@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Karol Lewandowski <k.lewandowsk@samsung.com>,
	Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
	Lennart Poettering <lennart@poettering.net>,
	John Stultz <john.stultz@linaro.org>,
	Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ryan Lortie <desrt@desrt.ca>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
 <20140320153250.GC20618@thunk.org>
 <CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com>
 <20140320163806.GA10440@thunk.org>
 <5346ED93.9040500@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5346ED93.9040500@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 12:14:27PM -0700, Andy Lutomirski wrote:
> 
> This is the second time in a week that someone has asked for a way to
> have a struct file (or struct inode or whatever) that can't be reopened
> through /proc/pid/fd.  This should be quite easy to implement as a
> separate feature.

What I suggested on a different thread was to add the following new
file descriptor flags, to join FD_CLOEXEC, which would be maniuplated
using the F_GETFD and F_SETFD fcntl commands:

FD_NOPROCFS	disallow being able to open the inode via /proc/<pid>/fd

FD_NOPASSFD	disallow being able to pass the fd via a unix domain socket

FD_LOCKFLAGS	if this bit is set, disallow any further changes of FD_CLOEXEC,
		FD_NOPROCFS, FD_NOPASSFD, and FD_LOCKFLAGS flags.

Regardless of what else we might need to meet the use case for the
proposed File Sealing API, I think this is a useful feature that could
be used in many other contexts besides just the proposed
memfd_create() use case.

Cheers,

					- Ted
