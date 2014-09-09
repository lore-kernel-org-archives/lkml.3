Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaIIHTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:19:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaIIHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:18:59 -0400
Date: Tue, 9 Sep 2014 09:18:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>,
        Takashi Iwai <tiwai@suse.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH] Hibernate: Do not assume the first e820 area to be RAM
Message-ID: <20140909071856.GA27512@amd>
References: <1407754252-22779-1-git-send-email-jlee@suse.com>
 <1561567.ev2pEO8C5v@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561567.ev2pEO8C5v@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-09-09 00:52:55, Rafael J. Wysocki wrote:
> On Monday, August 11, 2014 06:50:52 PM Lee, Chun-Yi wrote:
> > In arch/x86/kernel/setup.c::trim_bios_range(), the codes introduced
> > by 1b5576e6 (base on d8a9e6a5), it updates the first 4Kb of memory
> > to be E820_RESERVED region. That's because it's a BIOS owned area
> > but generally not listed in the E820 table:
> > 
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
> > [    0.000000] BIOS-e820: [mem 0x0000000000097000-0x0000000000097fff] reserved
> > ...
> > [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> > [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> > 
> > But the region of first 4Kb didn't register to nosave memory:
> > 
> > [    0.000000] PM: Registered nosave memory: [mem 0x00097000-0x00097fff]
> > [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
> > 
> > The codes in e820_mark_nosave_regions() assumes the first e820 area to be
> > RAM, so it causes the first 4Kb E820_RESERVED region ignored when register
> > to nosave. This patch removed assumption of the first e820 area.
> > 
> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
