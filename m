Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaG1NKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:10:22 -0400
Received: from imap.thunk.org ([74.207.234.97]:60541 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaG1NKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:10:18 -0400
Date: Mon, 28 Jul 2014 09:10:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?us-ascii?B?PT9VVEYtOD9RP01pY2hlbF9EPUMzPUE0bnplcj89?= 
	<michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140728131003.GO6725@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	=?us-ascii?B?PT9VVEYtOD9RP01pY2hlbF9EPUMzPUE0bnplcj89?= <michel@daenzer.net>,
	Jakub Jelinek <jakub@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Debian GCC Maintainers <debian-gcc@lists.debian.org>,
	Debian Kernel Team <debian-kernel@lists.debian.org>
References: <20140725035527.GA30108@pg-vmw-gw1>
 <20140725140237.GB32669@home.goodmis.org>
 <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
 <20140726201914.GB21842@x4>
 <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
 <y0m7g2xk6ss.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m7g2xk6ss.fsf@fche.csb>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:26:59AM -0400, Frank Ch. Eigler wrote:
> Please note that the data produced by "-g -fvar-tracking" is consumed
> by tools like systemtap, perf, crash, and makes a significant
> difference to the observability of debug AND non-debug kernels.  (The
> presence of compiled-in DEBUG_* self-checking code is orthogonal to
> kernel observability via debuginfo.)  Please consider only disabling
> var-tracking optionally/temporarily to work around this already-fixed
> compiler bug, but not losing high-quality dwarf data permanently.

I thought Markus told us that -fno-var-tracking-assignments makes
absolutely no difference for non-debug kernels?

For cases where it's really critical that userspace know whether a
particular kernel bug or feature is present, one of the tricks I use
is the presence or absense of a file in /sys/fs/ext4/features.  That
way, userspace can reliably detect if feature or bug fix is present,
without relying solely on a version check which doesn't take into
account enterprise distro backports.

Is there some equivalent signalling system that gcc could use, so that
the Makefile can test whether or not -fvar-tracking is needed to avoid
creating an unstable kernel, and which takes into account that (a)
some users will try building bleeding edge kernels on RHEL systems
that might not have the bug fix backported, and it would be nice if
they don't get a buggy compiled kernel, and (b) once the bug fix is
backported, companies like Red Hat would prefer that the workaround
gets disabled to avoid the side effects for things like Systemtap?

Hopefully such a feature will only be needed Very, VERY, *VERY*
rarely, but when the need arises, it's nice to have.

Regards,

						- Ted


