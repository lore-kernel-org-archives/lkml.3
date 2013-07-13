Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3GMAOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:14:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65338 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757928Ab3GMAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:14:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Date: Sat, 13 Jul 2013 02:24:07 +0200
Message-ID: <2354417.lhslZaMQMB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130712033430.GA3798@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org> <20130712025745.GA24086@tuxdriver.com> <20130712033430.GA3798@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 11, 2013 08:34:30 PM Greg Kroah-Hartman wrote:
> On Thu, Jul 11, 2013 at 10:57:46PM -0400, John W. Linville wrote:
> > On Thu, Jul 11, 2013 at 08:50:23PM -0400, Theodore Ts'o wrote:
> > 
> > > In any case, I've been very conservative in _not_ pushing bug fixes to
> > > Linus after -rc3 (unless they are fixing a regression or the bug fix
> > > is super-serious); I'd much rather have them cook in the ext4 tree
> > > where they can get a lot more testing (a full regression test run for
> > > ext4 takes over 24 hours), and for people trying out linux-next.
> > > 
> > > Maybe the pendulum has swung too far in the direction of holding back
> > > changes and trying to avoid the risk of introducing regressions;
> > > perhaps this would be a good topic to discuss at the Kernel Summit.
> > 
> > Yes, there does seem to be a certain ebb and flow as to how strict
> > the rules are about what should go into stable, what fixes are "good
> > enough" for a given -rc, how tight those rule are in -rc2 vs in -rc6,
> > etc.  If nothing else, a good repetitive flogging and a restatement of
> > the One True Way to handle these things might be worthwhile once again...
> 
> The rules are documented in stable_kernel_rules.txt for what I will
> accept.
> 
> I have been beating on maintainers for 8 years now to actually mark
> patches for stable, and only this past year have I finally seen people
> do it (we FINALLY got SCSI patches marked for stable in this merge
> window!!!)  So now that maintainers are finally realizing that they need
> to mark patches, I'll be pushing back harder on the patches that they do
> submit, because the distros are rightfully pushing back on me for
> accepting things that are outside of the stable_kernel_rules.txt
> guidelines.

I don't quite understand why they are pushing back on you rather than on
the maintainers who have marked the commits they have problems with for
-stable.  Why are you supposed to play the role of the gatekeeper here?
Can't maintainers be held responsible for the commits they mark for -stable in
the same way as they are responsible for the commits they push to Linus?

Also, I don't really think that the distros have problems with fixes that are
simple and provably correct, even though the problems they fix don't seem to be
"serious enough" for -stable.  They rather have problems with subtle changes
whose impact is difficult to estimate by inspection and you're not going to be
pushing back on those anyway (exactly because their impact is difficult to
estimate).

> If you look on the stable@vger list, I've already rejected 3 today and
> asked about the huge 21 powerpc patches.  Sure, it's not a lot, when
> staring down 174 more to go, but it's a start...

And 2 of those 3 rejected were mine and for 1 of them I actually had a very
specific reason to mark it for -stable as I told you: It fixed a breakage
introduced inadvertently in 3.10 and I thought it would be good to reduce
the exposure of that breakage by fixing it in 3.10.1 as well as in 3.11-rc.

Of course, you are free to disagree with that, but it's not like there was no
reason.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
