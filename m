Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3KZCug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:50:36 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:64839 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3KZCue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131126003919.GT14725@sirena.org.uk>
References: <20131125174037.GR14725@sirena.org.uk>
	<CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>
	<20131126003919.GT14725@sirena.org.uk>
Date: Mon, 25 Nov 2013 18:50:33 -0800
X-Google-Sender-Auth: vZUPp6XByr4dE44xZBMLyOOAWEY
Message-ID: <CA+55aFzwPZPTHGfDva0hZwnNStCioXUxtERkDdBo6ae+cbmKMw@mail.gmail.com>
Subject: Re: [GIT PULL] regulator updates for v3.13-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 4:39 PM, Mark Brown <broonie@kernel.org> wrote:
>
> If you're OK with octopus merges for things like this I'll definitely
> take another look at using them, the enormous stack of merge commits
> always looks noisy to me in the logs and pull requests and for things
> like driver updates there's unlikely to be much doubt about which branch
> it was if there's a problem.

Yeah, I'm definitely ok with octopus merges, and I do them myself
occasionally (especially with the -tip tree, which I get as many
separate pull requests - see for example commit 669fc2f0c70a).

And various maintainers use them too - Ingo does them for x86, Russell
King does them for ARM, Roland Dreier for infiniband, Paul McKenney
for rcu stuff, etc etc. Len Brown used to do them for ACPI all the
time.

But I do ask people to use them judiciously. Octopus merges are good
for the "many small topic branches" kind of thing. But they should
generally be avoided for big merges.

Obligatory git trick of the day:

    git rev-list --parents HEAD |
        egrep '^.{128}' |
        cut -d' ' -f1 |
        git log --no-walk --stdin --oneline

shows you the octopus merges. A couple of the older ones are bogus and
come from the bad old days when git didn't properly filter parent
lists, so there are redundant parents making a commit _look_ like an
octopus merge even though it's really just merging one branch. Maybe
Takashi hit one of those bugs back when..

                      Linus
