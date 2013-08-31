Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3HaKBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:01:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3HaKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:01:29 -0400
Date: Sat, 31 Aug 2013 12:01:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: 3.11-rc2: unpriviledged user crashes kernel using bluetooth
Message-ID: <20130831100127.GA6711@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While trying to set up serial bluetooth connection between two
machines, the server machine died rather hard.

This is what I got on ssh:

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
 03/31/2011

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:task: e6d6a670 ti: e8fd8000 task.ti: e8fd8000

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Stack:

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Call Trace:

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Code: 66 ff ff ff eb b9 ba 79 c9 b6 c0 89 d8 e8 58 ff ff ff eb
 a0 8d b6 00 00 00 00 55 89 e5 83 ec 10 89 5d f4 89 c3 89 75 f8 89 7d
 fc <81> 78 04 ad 4e ad de 0f 85 11 01 00 00 64 a1 4c 87 d2 c0 39 43

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:EIP: [<c04621f1>] do_raw_spin_lock+0x11/0x140 SS:ESP
 0068:e8fd9e0c

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:CPU: 0 PID: 3822 Comm: modem-manager Tainted: G      D W
 3.11.0-rc2+ #306

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )
 03/31/2011

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:task: e6d9a670 ti: e6d4e000 task.ti: e6d4e000

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Stack:

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Call Trace:

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:Code: 66 ff ff ff eb b9 ba 79 c9 b6 c0 89 d8 e8 58 ff ff ff eb
 a0 8d b6 00 00 00 00 55 89 e5 83 ec 10 89 5d f4 89 c3 89 75 f8 89 7d
 fc <81> 78 04 ad 4e ad de 0f 85 11 01 00 00 64 a1 4c 87 d2 c0 39 43

Message from syslogd@duo at Aug 31 11:50:07 ...
 kernel:EIP: [<c04621f1>] do_raw_spin_lock+0x11/0x140 SS:ESP
 0068:e6d4fe0c

. Python sources for client/server are at 

http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/

. My kernels like to warn about

Aug 31 11:46:37 duo kernel: WARNING: CPU: 1 PID: 1 at
net/wireless/reg.c:423 regulatory_init+0x92/0xff()
Aug 31 11:46:37 duo kernel: db.txt is empty, you should update it...

. 3.10 does not seem to be affected.
										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
