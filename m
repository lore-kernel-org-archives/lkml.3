Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaG3Kze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:55:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39378 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaG3Kzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:55:32 -0400
Date: Wed, 30 Jul 2014 12:55:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line
 argument for sleep state enumeration
Message-ID: <20140730105529.GB12448@amd.pavel.ucw.cz>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan>
 <3836835.YaZPGXsEQ2@vostro.rjw.lan>
 <34237308.7Kff3QYgup@vostro.rjw.lan>
 <2242480.eT2OxdNqLH@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2242480.eT2OxdNqLH@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> For this reason I'm considering changing the defaul behavior going forward (so
> that "mem" is always present and means "the deepest sleep state available other
> than hibernation"), but I don't want to do that in one go.

Actually, I don't think that's good idea, at least on PC.

The way to wake up from S3 is power button. The way to wake up from
"echo freeze > state" is going to be different, right?

If I disable S3 in the BIOS and get different result from "echo mem >
state", that will be confusing.

Similar (but less severe) problem is there with S1, as it will
probably power down USB ports, etc.

So for example if I have system with S1, learn to do "echo mem >
state" and that it still charges my phone, then ACPI updates come and
"echo mem > state" now puts it in S3 and not charging my phone -- that
would be confusing.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
