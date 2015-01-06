Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbbAFITa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:19:30 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:58062 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbbAFIT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:19:28 -0500
Message-ID: <1420532359.1966.0.camel@sipsolutions.net>
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 06 Jan 2015 09:19:19 +0100
In-Reply-To: <54AB0C75.1090204@broadcom.com>
References: <1420297188.2397.3.camel@tiscali.nl>
		 <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>
		 <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>
		 <1420324124.9624.60.camel@x220> <54AA641C.7050307@broadcom.com>
		 <1420479510.14308.23.camel@x220>
		 (sfid-20150105_183907_807502_81C08416) <1420484224.9459.16.camel@sipsolutions.net>
	 <1420495519.14308.29.camel@x220> <54AB0C75.1090204@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 23:13 +0100, Arend van Spriel wrote:
> On 01/05/15 23:05, Paul Bolle wrote:
> > On Mon, 2015-01-05 at 19:57 +0100, Johannes Berg wrote:
> >> Multiple other groups of ioctls could be converted in similar patches,
> >> until at the end you can completely remove ipw_wx_handlers and rely
> >> entirely on cfg80211's wext compatibility.
> >>
> >> So far the theory - in practice nobody cared enough to start working on
> >> any of these drivers, let alone actually has the hardware today.
> >
> > So my suggestion to make ipw2200 no longer use cfg80211_wext_giwname()
> > would actually be backwards. What's actually needed, in theory, is to
> > use more of what's provided under CFG80211_WEXT (and, I guess, less of
> > what's provided under WIRELESS_EXT). Did I get that right?
> 
> Yes, but as Johannes indicated it needs consideration what to group in 
> the patches.

Oh, that's not strictly necessary - that was just so it would actually
work after each single patch. If you wanted to, you could do it all in a
single huge patch as well :-) I was explaining though why we did the
cfg80211-wext code the way it is - which enables making smaller changes
that don't break the driver.

johannes

