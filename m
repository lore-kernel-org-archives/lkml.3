Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaG1M2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:28:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaG1M2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:28:34 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FMichel=5FD=3DC3=3DA4nzer=3F=3D?= 
	<michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net> <20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
	<CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
	<20140726193557.GA21842@x4>
	<CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
	<20140726201914.GB21842@x4>
	<CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 28 Jul 2014 08:26:59 -0400
In-Reply-To: <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com> (Linus Torvalds's message of "Sat, 26 Jul 2014 13:39:54 -0700")
Message-ID: <y0m7g2xk6ss.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


torvalds wrote:

> [...]
> Actually, I prefer my patch that did it with cc-option checking, and
> does it unconditionally.
>
> Because if we do it even for non-debug builds - where it ostensibly
> shouldn't matter - we then have that GCC_COMPARE_DEBUG thing working
> regardless of configuration.

Please note that the data produced by "-g -fvar-tracking" is consumed
by tools like systemtap, perf, crash, and makes a significant
difference to the observability of debug AND non-debug kernels.  (The
presence of compiled-in DEBUG_* self-checking code is orthogonal to
kernel observability via debuginfo.)  Please consider only disabling
var-tracking optionally/temporarily to work around this already-fixed
compiler bug, but not losing high-quality dwarf data permanently.

- FChE
