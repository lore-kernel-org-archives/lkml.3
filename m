Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbbAEBex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:34:53 -0500
Received: from imap.thunk.org ([74.207.234.97]:51174 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbbAEBew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:34:52 -0500
Date: Sun, 4 Jan 2015 20:34:36 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150105013436.GA23350@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd>
 <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150104212659.GC12302@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 09:26:59PM +0000, Russell King - ARM Linux wrote:
> 
> With the revert in place, we now have insanely small bogomips values
> reported via /proc/cpuinfo when hardware timers are used.  That needs
> fixing.

Why does it need to be fixed?

It's clear that there are applications that are working OK with the
existing value, and if you change it to fix it for some new
applications, but it breaks for others, then have you considered
defining a new interface (perhaps exported via sysfs) that exports a
"sane" value and document that new applications shoud use the new
interface.

Or if the answer is that no one should be using the bogomips field at
all, then just document *that*, and then leave it be, so that existing
applications don't break.

						- Ted
