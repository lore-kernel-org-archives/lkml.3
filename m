Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3JHOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:47:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39586 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3JHOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:47:09 -0400
Date: Tue, 8 Oct 2013 16:47:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Radek Pilar <mrkva@mrkva.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM - freeze & sync
Message-ID: <20131008144704.GA29729@xo-6d-61-c0.localdomain>
References: <50F96746.1080304@mrkva.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F96746.1080304@mrkva.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> I'm trying to implement feature that removes cryptsetup keys from RAM on
> suspend to RAM: mounts ramfs, unpacks initramfs to ramfs, moves /proc
> /dev and /sys to ramfs, chroots, calls luksSuspend, suspends system
> using /sys/power/state, after resume calls luksResume and cleans up.
> However, there is a small issue I wasn't able to solve: after calling
> luksSuspend, all attempts to access suspended device blocks - so most
> likely some processes won't be able to freeze. The same issue will be
> with sync just before suspend - if there are some data to be written,
> sync() blocks. If I comment out freeze and sync from the suspend code,
> it suspends (and wakes up) just fine - however, that patch will never be
> accepted.
> Is there any *correct* way to do this? (Skip freeze/sync on demand)?

Maybe uswsusp interface is powerful enough to do this?
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
