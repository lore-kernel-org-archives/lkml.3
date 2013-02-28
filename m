Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3B1Jpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:45:55 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:60272 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3B1Jpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:45:53 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130228073235.GP10026@vostochny.stro.at>
References: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
	<512E1061.3030007@suse.cz>
	<20130228073235.GP10026@vostochny.stro.at>
Date: Thu, 28 Feb 2013 10:45:51 +0100
Message-ID: <CA+icZUWkaULN_OH4A9qbw_g9Yayzcr8v3EFLYPYnUWDZqyR=qA@mail.gmail.com>
Subject: Re: [PATCH 1/3] kbuild, deb-pkg: Try to determine distribution
From: Sedat Dilek <sedat.dilek@gmail.com>
To: maximilian attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>, Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Wirt <formorer@debian.org>, Thorsten Glaser <tg@mirbsd.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 8:32 AM, maximilian attems <max@stro.at> wrote:
> On Wed, Feb 27, 2013 at 02:55:45PM +0100, Michal Marek wrote:
>> Sorry I missed this series. Max, can you have a look? I don't know the
>> policies for debian package changelogs. The full series is at
>> http://lkml.indiana.edu/hypermail/linux/kernel/1204.2/index.html#04252,
>> but the remaining two patches are obvious.
>
> the two remaining ones are trivial, should have pushed them a long time
> ago and will do so this weekend in a combined version going up to 2013
> (sitting in my queue to send).
>
>> On 24.4.2012 00:16, Sedat Dilek wrote:
>> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> > ---
>> >  scripts/package/builddeb |   15 ++++++++++++++-
>> >  1 file changed, 14 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
>> > index eee5f8e..f5b56ac 100644
>> > --- a/scripts/package/builddeb
>> > +++ b/scripts/package/builddeb
>> > @@ -172,9 +172,22 @@ else
>> >  fi
>> >  maintainer="$name <$email>"
>> >
>> > +# Try to determine distribution
>> > +if [ -e $(which lsb_release) ]; then
>> > +       codename=$(lsb_release --codename --short)
>> > +       if [ "$codename" != "" ]; then
>> > +           distribution=$codename
>> > +       else
>> > +           distribution="UNRELEASED"
>> > +           echo "WARNING: The distribution could NOT be determined!"
>> > +       fi
>> > +else
>> > +       echo "HINT: Install lsb_release binary, this helps to identify your distribution!"
>> > +fi
>> > +
>> >  # Generate a simple changelog template
>> >  cat <<EOF > debian/changelog
>> > -linux-upstream ($packageversion) unstable; urgency=low
>> > +linux-upstream ($packageversion) $distribution; urgency=low
>> >
>> >    * Custom built Linux kernel.
>
> this is pretty useless.
> Nack, in adding a this additional lsb dep.
> I know it should be installed by default, but in practise it is often not.
>
> If you'd really care about the changelog you'd generate it out of your
> git repo with Debian's git dch in order to have something meaningful.
>

[ CCing Thorsten and Alexander ]

Thank you for your response.

This was a compromise for Debian and Ubuntu systems and as said
discussed with two longterm Debian maintainers.
Thorsten Glaser uses same mechanisms in his Debian build-environments
(he prefers -cs as parameters than long-format).
FYI: Ubuntu/precise ships lsb(-release) stuff by default!
Can't say if it is a "essential" package on Debian these days or not
(in my patch there is a warning if it's not available).

Personally, I think lsb-release binary is a good compromise in a
non-Debian-world, too.
I don't know of a real distro not shipping it - not thinking of
distros like LFS (Linux From Scratch) in first place (and did not
verify even if LSB stuff is done or not, I might be wrong).

What's your proposal to check for $codename/$distribution (just curious)?

Last question:
Should people CC you always on patches for deb-pkg?
For me it looks like you are "maintaining" it, so why not place you as
a maintainer in MAINTAINERS file?
( Didn't check what checkpatch.pl throws out. )
So, you do the work - get the credits :-)!

- Sedat -

P.S.: Ubuntu/precise beta1 ships lsb-release.

# grep lsb packages_01_precise-beta1.txt
ii  lsb-base                               4.0-0ubuntu20
                 Linux Standard Base 4.0 init script functionality
ii  lsb-release                            4.0-0ubuntu20
                 Linux Standard Base version reporting utility

>
> --
> maks
