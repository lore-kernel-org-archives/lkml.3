Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaG1OL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaG1OL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:11:58 -0400
Date: Mon, 28 Jul 2014 10:11:37 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20140728141137.GF12073@redhat.com>
References: <20140725140237.GB32669@home.goodmis.org> <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com> <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com> <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com> <20140726193557.GA21842@x4> <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com> <20140726201914.GB21842@x4> <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com> <y0m7g2xk6ss.fsf@fche.csb> <20140728131003.GO6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728131003.GO6725@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Jul 28, 2014 at 09:10:04AM -0400, Theodore Ts'o wrote:
> [...]
> I thought Markus told us that -fno-var-tracking-assignments makes
> absolutely no difference for non-debug kernels?

It does affect CONFIG_DEBUG_INFO kernels, and that config option is
set for all Red Hat kernels (-debug or plain).


> [...]  Is there some equivalent signalling system that gcc could use
> [...]

I'm not aware of anything trivial like a gcc --report-fixed-PRs kind
of thing.  But, kbuild could conceivably have a run-time test
involving test-running gcc with in that compare-debug mode with a
suitable test case.  We use the latter technique in systemtap for
auto-configuring to kernel versions/features; we got the $(CHECK_BUILD)
trick from vmware module makefiles.  It could be recast as a variant
of $(cc-option ...).


- FChE
