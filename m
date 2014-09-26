Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaIZMzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:55:32 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:55083 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbaIZMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:55:31 -0400
Message-ID: <1411736128.7866.46.camel@x220>
Subject: Re: [GIT PULL] EFI urgent fixes
From: Paul Bolle <pebolle@tiscali.nl>
To: Matt Fleming <matt@console-pimps.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Fri, 26 Sep 2014 14:55:28 +0200
In-Reply-To: <20140926123429.GX18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
	 <20140925144127.GA3828@gmail.com> <1411730854.7866.10.camel@x220>
	 <20140926114454.GV18635@console-pimps.org> <1411732755.7866.24.camel@x220>
	 <20140926123429.GX18635@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 12:55:29.0294 (UTC) FILETIME=[264692E0:01CFD989]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 13:34 +0100, Matt Fleming wrote:
> On Fri, 26 Sep, at 01:59:15PM, Paul Bolle wrote:
> > 
> > I have a 800 line perl monster that checks for stuff like this. It's not
> > very sophisticated but smart enough to spot typos like this one. I try
> > to have it check each linux-next (and mainline) release.
>  
> Very cool.

Thanks.

> > (I think Valentin Rothberg is trying to automate this properly. See
> > http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)
> 
> Have either of you guys thought about asking for this to be included
> with the 0-day kbuild bot or submitted under scripts/?
> 
> It certainly seems like a useful bit of functionality.

I've been testing things locally for three months now. People must have
noticed an uptick in messages I send on this topic. (And, related, a
decrease in the numbers of cleanup patches I send myself.) I've not been
shouted at very often, so the signal to noise ratio is probably cool. 

This is about the third time I've written a monster like that. (I first
started checking for Kconfig related defects in, I think, 2011.)

About the only thing I'm happy with in this attempt is that it parses
blobs separately. Ie, every release it checks for previously unseen
blobs, parses those, and saves each blob level parse as a git note to
that blob. Then it collects all relevant blob level notes, does the
aggregate analysis and reports the issues it identifies. That report is
saved away again as a note on the tag I'm checking. (I have not bothered
to automate that last step.) The neat thing is, I think, that each
release touches only a minority of files so parsing the tree is mostly a
one time cost (encountered on the very first run).

But, anyhow, I'm pretty sure Valentin is onto something much more
sophisticated.

> Fengguang, the interesting bits of this thread start here,
> 
>   https://lkml.kernel.org/r/1411730854.7866.10.camel@x220


Paul Bolle

