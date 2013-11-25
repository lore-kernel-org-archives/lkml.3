Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3KYVKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:10:06 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56715 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3KYVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:10:02 -0500
MIME-Version: 1.0
In-Reply-To: <20131125174037.GR14725@sirena.org.uk>
References: <20131125174037.GR14725@sirena.org.uk>
Date: Mon, 25 Nov 2013 13:10:01 -0800
X-Google-Sender-Auth: bAu_SmX3O5yY7xT5kIL6dOogoMk
Message-ID: <CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>
Subject: Re: [GIT PULL] regulator updates for v3.13-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 9:40 AM, Mark Brown <broonie@kernel.org> wrote:
>
> Mark Brown (4):
>       Merge remote-tracking branch 'regulator/fix/arizona' into regulator-linus
>       Merge remote-tracking branch 'regulator/fix/fixed' into regulator-linus
>       Merge remote-tracking branch 'regulator/fix/gpio' into regulator-linus
>       Merge remote-tracking branch 'regulator/fix/pfuze100' into regulator-linus

Btw, I suspect you could/should have just used an "octopus merge" to
merge these kinds of small independent branches in one go. Just list
all the branches you want to merge for one single "git merge", and
you're done.

I don't necessarily recommend doing that in general, but octopus
merges are actually quite nice for this kind of situation in that it
avoids having excessive empty merge commits. Now we end up having your
four merges, and then my one merge on top: so we have five merges for
four actual fixes. Octopus merges can end up making the history more
readable by avoiding that kind of somewhat excessive merge activity
that you otherwise easily get from having lots of small topic
branches.

But it's up to you. I like seeing topic branches, and that part is
absolutely a good git habit to get into. Octopus merges then have the
upside that they then avoid having lots of pointless small merge
commits to tie them all together, but they can make it slightly more
challenging to figure out what went wrong if problems happen. So in
this case, one option might have been to merge the three independent
driver fixes with one single octopus merge, and then merge the core
fix separately as a normal merge.

Whatever. Not a big deal, I just thought I'd mention it if you perhaps
didn't realize that git happily merges multiple branches at once..

              Linus
