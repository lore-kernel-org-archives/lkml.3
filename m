Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab3GSKNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:13:37 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:40947 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3GSKNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:13:35 -0400
Date: Fri, 19 Jul 2013 12:13:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130719101330.GA26716@gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712051451.GC25815@1wt.eu>
 <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
 <s5hwqoqv4oo.wl%tiwai@suse.de>
 <20130716165933.GU22506@sirena.org.uk>
 <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
 <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...]
> 
> Anyway, the point I'm making is that Q&A is limited and often even 
> actively misleading ("Hey, I have three tested-by's, so it must be 
> fine"), and we might actually want to have a new class of "non-critical 
> patch that might be worth backporting to stable, but only do so after 
> it's been in a release for some time". Because while it might be an 
> "obvious" fix, maybe it's not critical enough that it needs to be 
> backported _now_ - maybe it could wait a month or two, and get wider 
> testing.

The way I typically mark those kinds of fixes is that I don't add a 
stable@vger.kernel.org tag to the commit and wait for explicit complaints 
to come up. I also sometimes remove -stable backport tags from fix 
submissions.

Requests for backports will arrive with a time delay (if at all), which 
gives the perfect opportunity to review its upstream status (whether there 
are followup problems with the patch, etc.) and forward the commit to 
-stable, at which point it's already been upstream for a couple of weeks, 
sometimes months.

I don't think this scenario needs to be or can be automated via a special 
tag: the main problem is that when the fix is applied we rarely know how 
widely users care about it. I think dealing with them 'statistically' 
(i.e. waiting for a backport request) measures that property pretty 
accurately.

The nice thing about it is that it all self-balances if people just add 
-stable backport tags more judiciously.

Thanks,

	Ingo
