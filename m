Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3HaKJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:09:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39983 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3HaKJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:09:35 -0400
Date: Sat, 31 Aug 2013 12:09:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc2: unpriviledged user crashes kernel using bluetooth
Message-ID: <20130831100933.GA7029@amd.pavel.ucw.cz>
References: <20130831100127.GA6711@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831100127.GA6711@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> . Python sources for client/server are at 
> 
> http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
> 
> . My kernels like to warn about
> 
> Aug 31 11:46:37 duo kernel: WARNING: CPU: 1 PID: 1 at
> net/wireless/reg.c:423 regulatory_init+0x92/0xff()
> Aug 31 11:46:37 duo kernel: db.txt is empty, you should update it...
> 
> . 3.10 does not seem to be affected.

When I said 3.10 was not affected, I was wrong. 3.10 survived the
test, but when I attempted to reboot the box, I got 

WARNING: at lib/list_debug.c:59 __list_del_entry+0xac/0xe0()
list_del_corruption. prev->next should be f44fffd4, but was f44c402c
...
...Comm: bluetoothd....
Call trace:
...
__list_del_entry
cd_forget
evict
iput

System is debian stable with gnome2.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
