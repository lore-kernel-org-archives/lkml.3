Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3GYMr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:47:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3GYMrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:47:52 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=X7p0W-CcHCoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=HTVI5EbAh76FNvT-uyEA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374756468.3356.172.camel@gandalf.local.home>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Thu, 25 Jul 2013 08:47:48 -0400
In-Reply-To: <CAMuHMdX3783c_HcB6eVJ5Tn-n8DVmgSi9F0LtYBZUk67HY9EcQ@mail.gmail.com>
References: <20130723220418.532514378@linuxfoundation.org>
	 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	 <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	 <20130724145506.GC15095@kroah.com>
	 <CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
	 <1374686174.3356.135.camel@gandalf.local.home>
	 <CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
	 <1374687963.3356.145.camel@gandalf.local.home>
	 <CAMuHMdX3783c_HcB6eVJ5Tn-n8DVmgSi9F0LtYBZUk67HY9EcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 11:52 +0200, Geert Uytterhoeven wrote:

> > I just find it funny to use git outside of a git environment. Perhaps
> > "git apply" should have another name? "pit"?
> 
> alias pit="git apply"?

I have no problem using patch.

> 
> Hmm, I never used "git apply". I more find myself using plain patch if
> "git am" doesn't want to take a patch due to the fuzz. Is there a fuzz
> parameter for "git am"? Is this "-C 2" or "-C 1"?
> 
> >> Most "true git" workflows end up using "git am" (or, better yet, "git
> >> pull" etc) to apply patches, which obviously not only does the --index
> >> thing, but also applies the changelog etc.
> >
> > I'm still somewhat old school, and my workflow uses git + quilt a bit. I
> > do a bunch of changes, then I do:
> >
> > git diff > foo.patch
> > patch -p1 -R < foo.patch
> > quilt import foo.patch
> > rm foo.patch
> 
> git commit -a
> 
> > And save off those changes to another time. When I get back to the
> > patch, I do:
> >
> > quilt push
> > <make final fixes>
> > quilt refresh
> > quilt pop
> 
> git commit -a --amend

I think you missed my point. I don't want to save the changes into git.
I do changes and store them away. It's much easier to search a patches
directory in git. Yeah, I can make a separate branch, but that becomes
unscalable rather quickly:


$ git branch | wc -l
296

> 
> > git apply --index < patches/foo.patch
> >
> > Sometimes I just leave off the pop and apply to do a git commit -a, but
> > then when I do a quilt pop I need to do a "git reset --hard" to reset
> > things. Having the patch in quilt gives me a nice record of what I did,
> > instead of searching through git history.
> >
> > Note, I do know about git quiltimport, but my quilt queue contains lots
> > of debug patches and things that are still pending (I modify the series
> 
> git rebase -i

What does that do for me?

> 
> My git "queue" contains 85 commits, some of them are 4 years old.
> I commit almost everything I do, and rework it until it's ready for submission.

quilt is a hell of a lot faster than git. And I deal with a bit more
than 85 commits:

$ ls patches | wc -l
313

Also, it becomes a pain to apply the same debug commits to different
branches. Sure, you can do git cherrypick, but that's all rather tedious
and awkward. quilt is much more appropriate for such a task.

> 
> > file a lot). What would help is to add an option to git quiltimport that
> > will limit the number of patches it imports.
> >
> > git quiltimport -c 1
> 
> vi series
> go to the first patch you don't want to apply
> dG
> :w
> CTRL-Z
> run quiltimpirt
> fg
> u
> :w
> 
> I never regretted the move from quilt (+ git) to git. To me quilt feels like
> having the disadvantages of "git rebase", without having its advantages.

I use both heavily. I use git for a lot of my workflow. I was only
stating some of my workflow sucks with git and works better with quilt.

> 
> The only feature from quilt I miss is the ability to put comments (mostly
> markers "for x.y", and separators and blank lines) in the series file.
> Managing the order of patches (and only that) in a quilt series file is still
> a bit more user-friendly than in a "git rebase -i" session.
> 
> Guess I should start using "git commit --allow-empty" to add markers?
> Hmm, probably git will complain again and again about empty commits
> when rebasing?

I use git rebase daily. But for other reasons. Clean ups, added tags,
late fixes, etc. All this before I push to next, as once I do that, I
try to avoid rebasing.

I don't think git is a replacement for quilt. To me, quilt is a very
nice complement to git.

-- Steve


