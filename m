Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3GXRYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:24:43 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42987 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3GXRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:24:40 -0400
MIME-Version: 1.0
In-Reply-To: <1374686174.3356.135.camel@gandalf.local.home>
References: <20130723220418.532514378@linuxfoundation.org>
	<CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
	<20130724145506.GC15095@kroah.com>
	<CA+55aFxdz6X8BfdzM5CwH_5Jmz=R1JMuLoo=r1yhWST+tKA7bw@mail.gmail.com>
	<1374686174.3356.135.camel@gandalf.local.home>
Date: Wed, 24 Jul 2013 10:24:39 -0700
X-Google-Sender-Auth: se91wa8o9XPEI3lJ_GYQHerzpEY
Message-ID: <CA+55aFyKRRDaohVPDSXZ5BRCHqAXAJv16EHS=aCj4B09VYrr6A@mail.gmail.com>
Subject: Re: [ 000/103] 3.10.3-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "gregkh@linuxfoundation.org >> Kroah-Hartman, Greg" 
	<gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:16 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I don't know why "git apply" doesn't do it by default. Why would you
> want to apply a patch without having git track new files?

There's a few reasons for the behavior:

 - it turns out that for most simple patches, you don't want to add
them to the index, and you want to stage them separately. Doing a "git
apply", you'd normally expect the end result to not be staged, so that
it shows up in "git diff", and then you can do your normal "git add"
or "git commit -a" or whatever. Yes, this means that you need to know
about new files, but the expected use is *not* to apply a patch
blindly and then not even care about the index.

 - "git apply" is actually also designed to be a *replacement* for
"patch". In particular, you can use it outside a git repository,
exactly like you'd use the standard "patch" program. Except unlike the
standard "patch" program, "git apply" doesn't accept fuzz by default
(which to me is a huge deal - I hate how "patch" tries to apply stuff
that clearly isn't valid any more) and also knows about things like
file modes and renames etc.

That second part is something not enough people use, and when I make
patches and tar-balls I still generate the old-style non-rename
patches etc for that reason. But basically the command is designed to
also be used in non-git environments, so the "standard usage" is very
much not the "involve git details" behavior.

Most "true git" workflows end up using "git am" (or, better yet, "git
pull" etc) to apply patches, which obviously not only does the --index
thing, but also applies the changelog etc.

            Linus
