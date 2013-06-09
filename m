Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab3FIRaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:30:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3FIRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:30:10 -0400
Date: Sun, 9 Jun 2013 19:30:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
        lauri.leukkunen@nokia.com
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130609173006.GC16066@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609015944.GA23559@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-06-09 03:59:44, Pavel Machek wrote:
> Hi!
> 
> I'd like to convert Nokia N900 to device tree.
> 
> Unfortunately, serial port is not easily available (very special cable
> would be needed, does someone know where to get one?) and I don't have
> BDI (and very special cable would be needed, too).
> 
> So I tried doing very small first step, hoping that I get booting
> system... obviously I did not.
> 
> I tried formally switching to device tree while still booting using
> hardcoded functions. No luck. Does anyone see what I did wrong?
> 
> Is it possible that n900 has its main memory somewhere else than
> 0x80000000?

Interesting. It seems that memory setup from atags is indeed 
	     0x8000 0000 size 0x0800 0000
	     0x8800 0000 size 0x0800 0000

. But hopefully that's just complicated way of saying 
	     0x8000 0000 size 0x1000 0000
	     
.

Anyway, I now see problem with my reasoning: kernel is full of

if (of_have_populated_dt())

tests, so it is impossible to switch to device tree, and still expect
old-style init to work :-(.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
