Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaK3A15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 19:27:57 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35532 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaK3A14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 19:27:56 -0500
Message-ID: <547A64BC.3020303@landley.net>
Date: Sat, 29 Nov 2014 18:28:44 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mparker@computer.org, linux-kernel@vger.kernel.org
Subject: Re: broken links on https://www.kernel.org/doc/
References: <CADBG5q8os3YNE__=7WQjuGTKErhw_bEa_JjyJsjaZqb8pQ16YQ@mail.gmail.com>
In-Reply-To: <CADBG5q8os3YNE__=7WQjuGTKErhw_bEa_JjyJsjaZqb8pQ16YQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/14 16:27, Matt Parker wrote:
> Howdy Rob,
> 
> I was following the links in "Videos worth watching" and found that the
> links for the videos on video.google.com <http://video.google.com> are
> broken, but I could find them on youtube.

Yeah, I know.

Updated links have been on http://landley.net/kdocs for years, but I
haven't been able to update kernel.org because the kernel guys took
rsync access away in the epic rounds of locking the barn door after the
horses escaped after kernel.org got broken into years ago.

There's a bugzilla thread on this, which boils down to "ever since the
Linux Foundation took over we've been paralyzed by bureaucracy", and I
got tired of fighting it.

https://bugzilla.kernel.org/show_bug.cgi?id=52721

The specific problem is they're convinced that git is the only tool you
can ever upload files to kernel.org with, just like it's the only tool
you can ever download files with. (After all, don't you watch those
youtube videos you mentioned through git? Just like every time you
compile a kernel all the intermediate object files are checked into git
so the linker can produce the executable.)

I pointed out that one of the things I wanted to upload again was the
2.8 gigabyte driver writing tutorial Greg KH had in his home directory
before the breakin, and that having 3 gigs of space permanently stuck in
a git repo even though it might go away again (it's now available on
http://video.linux.com/videos/write-a-real-linux-driver-greg-kh-2008 but
wasn't at the time) was a bad thing. To me this was just one obvious
example of how git was the _wrong_tool_ for this job, so of course they
never replied to this objection.

The last entry of the above bugzilla thread is me pointing them towards
an ssh configuration that _only_ allows a given user to rsync into a
single directory (no shell access, no access outside that directory), to
which they never replied. Not replying when I raise a point they don't
like is kinda the kernel guys' way.

I'd do things like complain about being unable to upload a new
kernel.org/doc/Documentation directory with html indexes, and they'd
make it a raw git checkout with no html indexes. (When I pointed out I
had a 00-index to html index converter script, which I was also using to
list files that aren't in 00-index or 00-index entries with no
corresponding file, they'd ignore me and then start a linux-kernel
thread about "does anybody use 00-index files for anything? Why do we
even have them? They don't always match the files that are there...")

I similarly poked them about the "make htmldocs" output not being
updated and they put the htmldocs output there... except I used to have
the "one big html file" version as well as the much of little files
versions, and of course they didn't reproduce that, and ignored me when
I pointed out they hadn't.

Another example is when I poked them about
https://www.kernel.org/doc/menuconfig/ being years out of date (last I
checked I can still generate it with my python script, but since I can't
upload the results why bother). So they removed the link to it from the
top page: problem solved!

(I note that none of these involved emailing me _back_, it was all
"silently do things to the website I notice weeks later".)

And yet despite editing the kernel.org/doc page several times since I
lost access to it (several more than just those examples), they never
took my name off it. So I get emails every few months from well-meaning
people, and I explain that the kernel.org developers care so little
about documentation they could never be bothered to understand what I
actually _did_, let alone restore my ability to do it.

That's basically why I gave up on kernel Documentation work and handed
maintainership back to Randy. I got tired of talking to a brick wall.

Rob
