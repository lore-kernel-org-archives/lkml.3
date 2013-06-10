Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3FJDGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:06:36 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:65486 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3FJDGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <51B53DAB.10501@ozlabs.org>
References: <1370764616.14883.28.camel@pasglop>
	<CA+55aFz_E+x=Mr9Z6_09wzh1mXFr3a2VigPX77LzrsyLUFeb+Q@mail.gmail.com>
	<CA+55aFxAC4EksZcz7SaZNjF9mfKkwLjWp2rEKxMZT8m-7uBeNQ@mail.gmail.com>
	<51B53DAB.10501@ozlabs.org>
Date: Sun, 9 Jun 2013 20:06:34 -0700
X-Google-Sender-Auth: Mwq3NAP20BRtnkENDAGW0dVPyAc
Message-ID: <CA+55aFzHT3NWrF6gq+BaLcZmEtrFwkiXv0_qZ0jGjxTO6-8iPQ@mail.gmail.com>
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

On Sun, Jun 9, 2013 at 7:44 PM, Jeremy Kerr <jk@ozlabs.org> wrote:
>
> We keep all patch dates in UTC, but were generating the Date header
> incorrectly. Now fixed:

No, not fixed.

Keeping patch dates in UTC *corrupts* the date.

I'll ask people to stop using patchworks if it cannot keep track of
emailed dates. The date very much is a local time WITH A TIMEZONE.

And it does matter.

> $ wget -qO - http://patchwork.ozlabs.org/patch/249598/mbox/ | grep ^Date
> Date: Fri, 07 Jun 2013 05:42:54 -0000

No. The date from the email was

    Date: Fri, 7 Jun 2013 15:42:54 +1000

and we want *that* date. Not some random date that patchwork makes up
that has no relevance.

I know you have that date, because it shows up when asking for the
headers in patchwork. Just use the right one, don't make up incorrect
ones.

               Linus
