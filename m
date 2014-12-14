Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaLNLQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 06:16:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52091 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLNLQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 06:16:25 -0500
Date: Sun, 14 Dec 2014 12:16:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141214111622.GA28560@amd>
References: <20141213223727.GA13894@amd>
 <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-12-14 00:30:13, Marcel Holtmann wrote:
> Hi Pavel,
> 
> > Add hci_h4p bluetooth driver to staging tree. This device is used
> > for example on Nokia N900 cell phone.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Thanks-to: Sebastian Reichel <sre@debian.org>
> > Thanks-to: Joe Perches <joe@perches.com>
> > 
> > ---
> > 
> > 
> > I'd prefer to resurect the driver in staging/ in order not to lose
> > history, but Marcel wanted to treat it as new submission, so I'm doing
> > that.
> 
> that history is in linux.git now for all times. No need to repeat it. I rather not play around with that again. Lets get a minimal driver merged so we can give people something to improve.
> 
> > 
> > Firmware load was converted to hci_cmd_sync(). Unfortunately, the
> > firmware is needed after every open/close, so the setup mechanism does
> > not quite fit. (But code is now way cleaner).
> 
> What is the reason for that? Does it mean that the device will always loose all its settings when powering it down. Do we know why that is that way and can we maybe change it?
> 
> If there is no way around this, we can introduce a quirk that will always run hdev->setup. However if the device keeps forgetting all settings all the time, that means it will also keep forgetting its address. So that power on procedure will be wasting time. We would need to check if we can make it so that it only has unconfigured state once and then keeps remembering the address even if we have to re-program it every time.
> 
> > Device tree bindings work for me, but they are not yet official and I
> > expect some more fun there.
> > 
> > Hacks surrounding bluetooth address were removed; this results in
> > working driver with address that is probably not unique.
> 
> Just set HCI_QUIRK_INVALID_BDADDR and let someone deal with that in
>userspace. You can use the btmgmt public-addr command for testing.

Hmm. So I installed bluez-5.36, then libudev-dev, then libical-dev,
libreadline-dev. I'm glad I have debian and not maemo, and nfsroot and
not limited flash.  I had to turn off systemd support.

It still compiles..
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
