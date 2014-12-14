Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLNVw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 16:52:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36730 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaLNVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 16:52:47 -0500
Date: Sun, 14 Dec 2014 22:52:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141214215243.GA22749@amd>
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

Hi!

> > Firmware load was converted to hci_cmd_sync(). Unfortunately, the
> > firmware is needed after every open/close, so the setup mechanism does
> > not quite fit. (But code is now way cleaner).
> 
> What is the reason for that? Does it mean that the device will always loose all its settings when powering it down. Do we know why that is that way and can we maybe change it?
>

Well, on hci_close(), original code asserts reset GPIO. I guess that
clears everything... I got it working with that removed, and it means
I can set the address the normal way. What are implications for power
consumption... I'm not sure at this point. Lets worry about that
later.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
