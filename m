Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaEBJAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:00:09 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54984 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBJAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140502055127.GH18016@ZenIV.linux.org.uk>
References: <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
	<20140429181610.GJ18016@ZenIV.linux.org.uk>
	<20140429191015.GK18016@ZenIV.linux.org.uk>
	<20140429211851.GA32204@dastard>
	<20140429214842.GL18016@ZenIV.linux.org.uk>
	<CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
	<20140429232013.GM18016@ZenIV.linux.org.uk>
	<20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
	<20140502055127.GH18016@ZenIV.linux.org.uk>
Date: Fri, 2 May 2014 11:00:04 +0200
X-Google-Sender-Auth: _lrdOQ0dHRFljPTpt49jZiUWy4s
Message-ID: <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Szeredi Miklos <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 7:51 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Apr 30, 2014 at 11:15:15AM +0200, Miklos Szeredi wrote:

>> IBM is triggering this with the host01 test from the LTP suite.  I haven't yet
>> tried to reproduce it.
>
> Could you repost their report?  So far I hadn't managed to get actual list
> corruption on mainline kernel - it definitely is possible, but on all
> testcases so far the race window is too narrow.  So if they have a reproducer
> that doesn't take an insane amount of time, I'd really like to see it...

The only reproducer they have is LTP/host01, and can trigger the bug
reliably within hours.

The bug is private, but I'll ask if I can repost it.  The first thing
is a a warning from the D_FLAG_VERIFY() in d_shrink_del() from
shrink_dentry_list().  They added printks that show that the dentry
has DCACHE_DENTRY_KILLED.

We could ask for a dump, but this is the only rational explanation I
could find for this (and a shrink list with two dentries, with racing
dput on both nicely explains the case where the shrink list's prev
pointer still points to the already killed dentry).

Thanks,
Miklos
