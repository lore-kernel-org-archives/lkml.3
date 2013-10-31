Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3JaXxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:53:09 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:54111 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3JaXxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <xmqqa9hp9x2e.fsf@gitster.dls.corp.google.com>
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda>
 <20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf>
 <526CA7D4.1070904@alum.mit.edu> <20131027071407.GA11683@leaf>
 <526E283A.1070801@alum.mit.edu> <CALKQrgfsk3fjyF77XL9+CPyJ_s-AfzkNAj4Eaj1LT-G0Ph=bfg@mail.gmail.com>
 <20131029020824.GE11861@sigill.intra.peff.net> <CALKQrge8T8R7roUUYyLcu_QnL1afeqTATOp+0n_OOsZZoJXF4Q@mail.gmail.com>
 <CACsJy8DVSpmmDw-jGJoJK171u5UeJR7GKPuX7QAK4=7yYn6n8Q@mail.gmail.com> <xmqqa9hp9x2e.fsf@gitster.dls.corp.google.com>
From: Duy Nguyen <pclouds@gmail.com>
Date: Fri, 1 Nov 2013 06:52:35 +0700
Message-ID: <CACsJy8CEnKxmhRYQqWoMVyLpfDUp7tqdnLxiV47XqaOFFCcUMw@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
To: Junio C Hamano <gitster@pobox.com>
Cc: Johan Herland <johan@herland.net>, Jeff King <peff@peff.net>,
        Michael Haggerty <mhagger@alum.mit.edu>,
        Josh Triplett <josh@joshtriplett.org>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 12:20 AM, Junio C Hamano <gitster@pobox.com> wrote:
> Duy Nguyen <pclouds@gmail.com> writes:
>
>> OK how about, if $GIT_DIR/hooks/something is a directory, then the
>> directory must contain a file named "index", listing all the hooks of
>> type "something". All the hooks in "index" will be executed in the
>> listing order.
>
> Hooks that take arbitrary amount of information from the body read
> their standard input. How are your multiple hooks supposed to
> interact?

If each only needs to read a few lines from stdin, they can do so in
order. If two hooks need to read till the end of stdin, they are
incompatible. If we support some sort of hook signature, we could warn
the user when they combine the two. If not, the second's failing
(because stdin is already closed) may show the incompatibility. "git
hook" should support dry-run mode to test out new combinations.

> Hooks that prevent you from doing something stupid signal allow/deny
> with their exit code. Do you fail a commit if any of your pre-commit
> hook fails, or is it OK to commit as long as one of them says so?
> If the former, do all the hooks described in the index still run, or
> does the first failure short-cut the remainder?

One failed hook fails the commit and stops the remaining from
executing. You can skip the hook if you want with --exclude-hooks.
-- 
Duy
