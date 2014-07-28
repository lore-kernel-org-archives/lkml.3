Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaG1Tu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:50:27 -0400
Received: from imap.thunk.org ([74.207.234.97]:33077 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaG1Tu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:50:26 -0400
Date: Mon, 28 Jul 2014 15:50:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alexei Starovoitov <ast@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140728195011.GD17378@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alexei Starovoitov <ast@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
	Jakub Jelinek <jakub@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Debian GCC Maintainers <debian-gcc@lists.debian.org>,
	Debian Kernel Team <debian-kernel@lists.debian.org>
References: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
 <20140726201914.GB21842@x4>
 <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
 <y0m7g2xk6ss.fsf@fche.csb>
 <CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
 <20140728172737.GA17598@pg-vmw-gw1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728172737.GA17598@pg-vmw-gw1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:27:39AM -0700, Alexei Starovoitov wrote:
> 
> It's not pretty, but adding it unconditionally was the right thing to do.
> Black listing compiler versions is too fragile.
> Look at the flip side: now size of build dir will be much smaller :)

White-listing the fixed compiler version should be safe though, and
that should pretty much fix things for community distros fairly
quickly.  For enterprise distros, once the compiler is patched, their
kernel sources could also be hacked to add a distro-specific version
whitelist.  This would all be fixed in 4.9.2, right?

							- Ted
