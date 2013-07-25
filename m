Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3GYJw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:52:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33653 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3GYJwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <1374687963.3356.145.camel@gandalf.local.home>
References: <20130723220418.532514378@linuxfoundation.org>
	<CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	<20130724145506.GC15095@kroah.com>
	<CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
	<1374686174.3356.135.camel@gandalf.local.home>
	<CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
	<1374687963.3356.145.camel@gandalf.local.home>
Date: Thu, 25 Jul 2013 11:52:53 +0200
X-Google-Sender-Auth: LKoC1wMvReU5FadXd1k9g5q81bo
Message-ID: <CAMuHMdX3783c_HcB6eVJ5Tn-n8DVmgSi9F0LtYBZUk67HY9EcQ@mail.gmail.com>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 7:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2013-07-24 at 10:24 -0700, Linus Torvalds wrote:
>> On Wed, Jul 24, 2013 at 10:16 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>  - "git apply" is actually also designed to be a *replacement* for
>> "patch". In particular, you can use it outside a git repository,
>
> OK, this makes more sense.
>
>> exactly like you'd use the standard "patch" program. Except unlike the
>> standard "patch" program, "git apply" doesn't accept fuzz by default
>> (which to me is a huge deal - I hate how "patch" tries to apply stuff
>> that clearly isn't valid any more) and also knows about things like
>> file modes and renames etc.
>
>> That second part is something not enough people use, and when I make
>> patches and tar-balls I still generate the old-style non-rename
>> patches etc for that reason. But basically the command is designed to
>> also be used in non-git environments, so the "standard usage" is very
>> much not the "involve git details" behavior.
>
> I just find it funny to use git outside of a git environment. Perhaps
> "git apply" should have another name? "pit"?

alias pit="git apply"?

Hmm, I never used "git apply". I more find myself using plain patch if
"git am" doesn't want to take a patch due to the fuzz. Is there a fuzz
parameter for "git am"? Is this "-C 2" or "-C 1"?

>> Most "true git" workflows end up using "git am" (or, better yet, "git
>> pull" etc) to apply patches, which obviously not only does the --index
>> thing, but also applies the changelog etc.
>
> I'm still somewhat old school, and my workflow uses git + quilt a bit. I
> do a bunch of changes, then I do:
>
> git diff > foo.patch
> patch -p1 -R < foo.patch
> quilt import foo.patch
> rm foo.patch

git commit -a

> And save off those changes to another time. When I get back to the
> patch, I do:
>
> quilt push
> <make final fixes>
> quilt refresh
> quilt pop

git commit -a --amend

> git apply --index < patches/foo.patch
>
> Sometimes I just leave off the pop and apply to do a git commit -a, but
> then when I do a quilt pop I need to do a "git reset --hard" to reset
> things. Having the patch in quilt gives me a nice record of what I did,
> instead of searching through git history.
>
> Note, I do know about git quiltimport, but my quilt queue contains lots
> of debug patches and things that are still pending (I modify the series

git rebase -i

My git "queue" contains 85 commits, some of them are 4 years old.
I commit almost everything I do, and rework it until it's ready for submission.

> file a lot). What would help is to add an option to git quiltimport that
> will limit the number of patches it imports.
>
> git quiltimport -c 1

vi series
go to the first patch you don't want to apply
dG
:w
CTRL-Z
run quiltimpirt
fg
u
:w

I never regretted the move from quilt (+ git) to git. To me quilt feels like
having the disadvantages of "git rebase", without having its advantages.

The only feature from quilt I miss is the ability to put comments (mostly
markers "for x.y", and separators and blank lines) in the series file.
Managing the order of patches (and only that) in a quilt series file is still
a bit more user-friendly than in a "git rebase -i" session.

Guess I should start using "git commit --allow-empty" to add markers?
Hmm, probably git will complain again and again about empty commits
when rebasing?

Andrew: Anything else why you're still using quilt?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
