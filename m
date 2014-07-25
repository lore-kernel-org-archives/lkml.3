Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbaGYV1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:27:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaGYV1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:27:16 -0400
Date: Fri, 25 Jul 2014 23:25:55 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140725212555.GG2397@laptop.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
 <20140723190230.GH3935@laptop>
 <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
 <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <53D1B1EF.7030603@daenzer.net>
 <20140725035527.GA30108@pg-vmw-gw1>
 <20140725140237.GB32669@home.goodmis.org>
 <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFxbWfYPuzCZvhy24zVfWwhN=DcxrCDguZ74cfsOz9U7PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxbWfYPuzCZvhy24zVfWwhN=DcxrCDguZ74cfsOz9U7PQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:01:11PM -0700, Linus Torvalds wrote:
> For example, gcc will not create a small stack frame with "sub
> $8,%rsp". No, what gcc does is to use a random "push" instruction.
> Fair enough, but that really makes things much harder to see. Here's
> an example:

That is because for -Os, push is certainly shorter than sub $8,%rsp.

If you want to test for this gcc bug in the kernel, supposedly one should
just take the short testcase from the GCC PR, try to compile it and see if
you e.g. get a -fcompare-debug -Os failure with the testcase.
In that case, you could instead of giving up completely just
-fno-var-tracking-assignments.

	Jakub
