Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaFUSCF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 14:02:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44803 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaFUSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 14:02:04 -0400
Date: Sat, 21 Jun 2014 20:02:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
        Greg KH <greg@kroah.com>, acourbot@nvidia.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140621180201.GA4621@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

AFAICT, pstate file will contain something like

07: core 100 MHz memory 123 MHz *
08: core 100-200 MHz memory 123 MHz

...which does not look exactly like one-value-per-file, and I'm pretty
sure userspace will get it wrong if it tries to parse it. Plus, I
don't see required documentation in Documentation/ABI.

Should we disable it for now, so that userspace does not start
depending on it and we'll not have to maintain it forever?

I guess better interface would be something like

pstate/07/core_clock_min
          core_clock_max
	  memory_clock_min
	  memory_clock_max

and then pstate/active containing just the number of active state?

Thanks,
								Pavel

PS: I have no nvidia, got the news at

http://www.phoronix.com/scan.php?page=article&item=nouveau_try_linux316&num=2
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
