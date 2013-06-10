Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3FJDUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:20:11 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:34158 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3FJDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
References: <1370764616.14883.28.camel@pasglop>
	<CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
	<CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com>
	<51B53DAB.10501@ozlabs.org>
	<CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
Date: Sun, 9 Jun 2013 20:20:09 -0700
X-Google-Sender-Auth: 5hm538eHSQLrgjo7oHqcZz2c_w4
Message-ID: <CA+55aFxJxY3J2X7DsEY4nz050PmNFgsZRewQEPoVWc1gzdiLGw@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patchwork ML <patchwork@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 8:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And it does matter.

.. the rationale for this is that the work pattern of people is
actually interesting information. You can do things like this:

    git log --pretty=%aD --author=Torvalds

to see what my work pattern is, and I think that's *interesting*.
Gathering statistics like whether people are generally doing 9-5
Mon-Fri is actually interesting data. You can do things like this:

    git log --since=6.months --pretty=%aD --author=Torvalds |
        cut -c1-3 |
        sort |
        uniq -c |
        sort -n

and see (for example) that I do slow down on weekends.

Same goes for things like what time of day ends up being most
productive. You can do the statistics for me, and see that I tend to
do the bulk of my pulls in the mornings (peak between 9-11) and that
I'm not a night-owl (*big* drop-off after 8PM - that's what kids do to
you). You can see a few really early-morning cases, but I suspect they
were when I was jetlagged.

So the date data is actually meaningful data. It's not just random noise.

And to do these kinds of things, you absolutely have to have
local-time with proper timezone information. Anything that screws that
up is *broken*. git gets this right, unlike a lot of other broken
SCM's. Git gets it right for a reason.

Yeah, yeah, when people forward other peoples patches they often drop
the date field, and the date of the patch ends up being the time that
the last version of the patch got sent rather than anything else, so
many of the statistics aren't valid. But a _tool_ that actively
corrupts the date and time of a patch is just broken.

                 Linus
