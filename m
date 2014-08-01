Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaHANf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:35:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53952 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932200AbaHANf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:35:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument for sleep state enumeration
Date: Fri, 01 Aug 2014 15:54:32 +0200
Message-ID: <3319219.i7p5TE6seQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140730105529.GB12448@amd.pavel.ucw.cz>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan> <2242480.eT2OxdNqLH@vostro.rjw.lan> <20140730105529.GB12448@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2014 12:55:29 PM Pavel Machek wrote:
> Hi!
> 
> > For this reason I'm considering changing the defaul behavior going forward (so
> > that "mem" is always present and means "the deepest sleep state available other
> > than hibernation"), but I don't want to do that in one go.
> 
> Actually, I don't think that's good idea, at least on PC.
> 
> The way to wake up from S3 is power button. The way to wake up from
> "echo freeze > state" is going to be different, right?

No, it isn't.  That's the point among other things.

> If I disable S3 in the BIOS and get different result from "echo mem >
> state", that will be confusing.

It may or may not be, depending on how different the handling of the states
is.  It shouldn't be much different.

> Similar (but less severe) problem is there with S1, as it will
> probably power down USB ports, etc.

Hmm.  S1 is implemented very rarely AFAICS and usually it works in analogy
with suspend-to-idle, but in the firmware.

> So for example if I have system with S1, learn to do "echo mem >
> state" and that it still charges my phone, then ACPI updates come and
> "echo mem > state" now puts it in S3 and not charging my phone -- that
> would be confusing.

Yes, it would.

Rafael

