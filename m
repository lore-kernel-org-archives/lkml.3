Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3GLR7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:59:15 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:58890 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3GLR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <1373651458.17876.103.camel@gandalf.local.home>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130712005023.GB31005@thunk.org>
	<20130712025745.GA24086@tuxdriver.com>
	<20130712033430.GA3798@kroah.com>
	<51E03AEE.5010403@zytor.com>
	<20130712172836.GA7627@kroah.com>
	<1373651458.17876.103.camel@gandalf.local.home>
Date: Fri, 12 Jul 2013 10:59:13 -0700
X-Google-Sender-Auth: H3dyV91p1_mPfedHf_UBkeq-DfE
Message-ID: <CA+55aFw6_1Lx-vJE=JGXbR_YYhWMqB+w69R1jDAcOrNCQc515Q@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Perhaps just make a separate stable branch, where you cherry-pick the
> specific patch using the -x option. Adds a "(cherry picked from
> commit ...)". Then you could have some filter that monitors Linus
> commits and when a commit matches one of these patches, have it
> automatically sent to the stable list.

Actually, please don't use -x very much. It doesn't much help, and it
can get very confusing before things are merged, and people who are on
one branch don't even see the other "identical" commit.

But cherry-picking patches is fine, if they really are stable
material. Feel free to send me a patch during -rc4 that ends up *also*
being in your tree for the next merge window, and don't worry too much
about it. It will cause merge problems if you then have other patches
on top of it that touch the same code, but for stable-quality patches
those tend to be really easy to fix up ("Oh, both branches already
have this patch, I should obviously take the version from the branch
that has five other patches on top too"), and most of the time it
merges cleanly anyway because there isn't anything else right there on
top of it anyway.

In fact, I'd *much* rather see the same fix committed twice in two
different maintainer trees than see cross-maintainership merges, which
is what some people do in order to pick up some trivial fix. The
cross-maintainership merges are much more painful, and tend to result
in "Oh, I didn't send in this pull request in a timely manner in the
merge window, because I was waiting for that *other* pull request to
go through first".

If it's that kind of a critical patch, it really probably *should* go
in twice. Of course, if it gets more complicated and bigger, then
duplicating the fix is a bad idea, and then you might want to have a
separate branch just for that particular fix.

                   Linus
