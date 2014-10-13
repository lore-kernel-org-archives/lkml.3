Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaJMQnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:43:45 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42349 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbaJMQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:43:42 -0400
Date: Mon, 13 Oct 2014 09:43:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-input@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vojtech Pavlik <vojtech@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - disable active multiplexing by default
Message-ID: <20141013164338.GA35440@dtor-ws>
References: <20141010205131.GA3271@dtor-ws>
 <20141012143039.GC378@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012143039.GC378@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sun, Oct 12, 2014 at 04:30:39PM +0200, Pavel Machek wrote:
> On Fri 2014-10-10 13:51:31, Dmitry Torokhov wrote:
> > Active multiplexing is a nice feature as it allows several pointing devices
> > (such as touchpad and external mouse) use their native protocols at the
> > same time. Unfortunately many manufacturers do not implement the feature
> > properly even though they advertise it. The problematic implementations are
> > never fixed, since Windows by default does not use this mode, and move from
> > one BIOS/model of laptop to another. When active multiplexing is broken
> > turning it on usually results in touchpad, keyboard, or both unresponsive.
> > 
> > With PS/2 usage on decline (most of PS/2 devices in use nowadays are
> > internal laptop touchpads), I expect number of users who have laptops with
> > working MUX implementation, docking stations with external PS/2 ports, and
> > who are still using external PS/2 mice, to be rather small. Let's flip the
> > default to be OFF and allow activating it through i8042.nomux=0 kernel
> > option.  We'll also keep DMI table where we can record known good models.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Could we keep the old default / blacklist for the old laptops? We did
> something like that for ACPI, based on year of the bios.
> 

I would prefer not to. Unlike ACPI we do not see any improvement or
decline in quality of MUX implementation over time. The implementations
were buggy 10 years ago, 5 years go and they are buggy now. So there is
not a point in time to draw a line at.

> Old laptops are not being made any more, so blacklist will not grow
> too fast...

It is already quite big and I do not believe we've gotten nearly all of
them. I guess in many cases people would try Linux, find that
keyboard/mouse do not work at all and they are done and not bother
filing bugs/reaching out on LKML, etc.

Again, the only people would might be negatively affected are people who
have proper implementation of active MUX, who use both touchpad and
external mouse at the same time and want touchpad in native mode, and who
use PS/2 external mice.

Thanks.

-- 
Dmitry
