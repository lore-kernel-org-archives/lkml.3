Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaBRR4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:56:45 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41738 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaBRR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:56:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XcwPSynIpj4ZgrMezApwKnFpyzTtSacc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 19FB752BD4A
Date: Tue, 18 Feb 2014 12:56:24 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140218175624.GY7862@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <201402121251.06280.arnd@arndb.de>
 <20140217155419.682F7C401D4@trevor.secretlab.ca>
 <1418981.0py7JxXCp8@wuerfel>
 <20140217182312.GV7862@titan.lakedaemon.net>
 <CAMuHMdW7S=o4oHVsNtYo0i_giB5cgWhygo-GgSaA1Kur6m3vng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW7S=o4oHVsNtYo0i_giB5cgWhygo-GgSaA1Kur6m3vng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:07:50PM +0100, Geert Uytterhoeven wrote:
> On Mon, Feb 17, 2014 at 7:23 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> Could we use a faster hash function that scans the entire device tree and
> >> then just feed the output of that into add_device_randomness? We probably
> >> can't expect that there is a lot of entropy in the DT blob, so the
> >> result wouldn't be all that different in terms of quality of the random
> >> seed.
> >
> > I think it would be easier to identify the few attributes that differ
> > from board to board (mac address, serial number, etc), and differ from
> > boot to boot (random-seed, timestamp) and just extract and feed those
> > in.
> 
> Isn't identifying those (mostly) a manual process?
> Calculating a fast hash is fully automatic.

The list would be pretty short, and once created wouldn't likely change
too often.  But it really depends on the 'fast hash'.  if the two
methods have comparable speed, I'd definitely prefer the hash.  Easier
to maintain.

thx,

Jason.
