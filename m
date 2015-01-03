Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbbACW2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 17:28:51 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:65368 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbbACW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 17:28:47 -0500
Message-ID: <1420324124.9624.60.camel@x220>
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2015 23:28:44 +0100
In-Reply-To: <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>
References: <1420297188.2397.3.camel@tiscali.nl>
	 <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>
	 <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2015 22:28:44.0564 (UTC) FILETIME=[A2598540:01D027A4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-03 at 10:07 -0800, Linus Torvalds wrote:
> On Sat, Jan 3, 2015 at 10:02 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> >
> > why would you revert this? It is obviously the correct change to actually select CFG80211_WEXT.
> 
> I don't know about obvious, but yeah, I think the select in this case
> is actually the better idea anyway.

Obviously it wasn't obvious to me!

My reasoning was that the "ipw2200: select CFG80211_WEXT" commit was
_solely_ a workaround for the breakage introduced by that other patch.
And since that one is now reverted the workaround wasn't needed anymore.

Besied, I thought we try to avoid select-ing symbols that can also be
set manually. As that makes it more likely to trigger circular
dependency problems in the kconfig tools, doesn't it?

> We could make the CFG80211_WEXT help message be very negative so that
> people aren't encouraged to select it even if they can, but then if
> they need the ipw driver it gets selected because of that. Because the
> ipw driver is probably the more important of the two if you just
> happen to have old hardware but are upgrading yout software (and
> anybody who recompiles their own kernel is obviously doing the
> latter).

Side note: am I correct in thinking that there's some successor to
CFG80211_WEXT and that the ipw2200 driver could, at least in theory, be
ported to that successor? (ipw2200 hardware appears to be a bit old, so
probably no one would care enough to actually do that.)
net/wireless/kconfig doesn't mention anything like that, so probably I'm
just confused.


Paul Bolle

