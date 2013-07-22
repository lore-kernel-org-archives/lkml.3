Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3GVOfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:35:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab3GVOfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:35:30 -0400
Date: Mon, 22 Jul 2013 16:35:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: benjamin.tissoires@gmail.com, adlr@chromium.org,
        joseph.salisbury@canonical.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
In-Reply-To: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
Message-ID: <alpine.LNX.2.00.1307221633010.23128@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Nestor Lopez Casado wrote:

> This reverts commit 8af6c08830b1ae114d1a8b548b1f8b056e068887.
> 
> This patch re-adds the workaround introduced by 596264082f10dd4
> which was reverted by 8af6c08830b1ae114.
> 
> The original patch 596264 was needed to overcome a situation where
> the hid-core would drop incoming reports while probe() was being
> executed.
> 
> This issue was solved by c849a6143bec520af which added
> hid_device_io_start() and hid_device_io_stop() that enable a specific
> hid driver to opt-in for input reports while its probe() is being
> executed.
> 
> Commit a9dd22b730857347 modified hid-logitech-dj so as to use the
> functionality added to hid-core. Having done that, workaround 596264
> was no longer necessary and was reverted by 8af6c08.
> 
> We now encounter a different problem that ends up 'again' thwarting
> the Unifying receiver enumeration. The problem is time and usb controller
> dependent. Ocasionally the reports sent to the usb receiver to start
> the paired devices enumeration fail with -EPIPE and the receiver never
> gets to enumerate the paired devices.
[ ... snip ... ]

Ok, this is now in

	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-3.11/logitech-enumeration-fix

Linus added to CC.

Linus -- could you please by any chance test whether the two patches in 
that branch make the problem you are observing any better? (and no, this 
is not a pull request yet).

It's still not clear whether we are chasing two different issues here, or 
not.

Thanks,

-- 
Jiri Kosina
SUSE Labs
