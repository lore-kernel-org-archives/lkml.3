Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaJLOas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:30:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38326 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaJLOam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:30:42 -0400
Date: Sun, 12 Oct 2014 16:30:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - disable active multiplexing by default
Message-ID: <20141012143039.GC378@amd>
References: <20141010205131.GA3271@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010205131.GA3271@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-10 13:51:31, Dmitry Torokhov wrote:
> Active multiplexing is a nice feature as it allows several pointing devices
> (such as touchpad and external mouse) use their native protocols at the
> same time. Unfortunately many manufacturers do not implement the feature
> properly even though they advertise it. The problematic implementations are
> never fixed, since Windows by default does not use this mode, and move from
> one BIOS/model of laptop to another. When active multiplexing is broken
> turning it on usually results in touchpad, keyboard, or both unresponsive.
> 
> With PS/2 usage on decline (most of PS/2 devices in use nowadays are
> internal laptop touchpads), I expect number of users who have laptops with
> working MUX implementation, docking stations with external PS/2 ports, and
> who are still using external PS/2 mice, to be rather small. Let's flip the
> default to be OFF and allow activating it through i8042.nomux=0 kernel
> option.  We'll also keep DMI table where we can record known good models.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Could we keep the old default / blacklist for the old laptops? We did
something like that for ACPI, based on year of the bios.

Old laptops are not being made any more, so blacklist will not grow
too fast...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
