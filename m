Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3AMWLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 17:11:51 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39590 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3AMWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:11:50 -0500
MIME-Version: 1.0
Date: Sun, 13 Jan 2013 23:11:49 +0100
Message-ID: <CADpTngVYgS1nefgYO+fpBWkQ+XvvdE7RL1kV5cP4TLsKkU2i-Q@mail.gmail.com>
Subject: rf kill button not working on hp folio 9470m - bisected
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
on my laptop (hp folio 9470m), the rfkill button works fine on 3.6.10
and 11 (don't know about older kernels), but is not working on 3.7.X
(latest tested is 3.7.2).
On non working kernel, log shows the following messages:

Jan 13 17:34:33 calvin kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0xf8 on isa0060/serio0).
Jan 13 17:34:33 calvin kernel: atkbd serio0: Use 'setkeycodes e078
<keycode>' to make it known.
Jan 13 17:34:33 calvin kernel: atkbd serio0: Unknown key released
(translated set 2, code 0xf8 on isa0060/serio0).
Jan 13 17:34:33 calvin kernel: atkbd serio0: Use 'setkeycodes e078
<keycode>' to make it known.
Jan 13 17:34:34 calvin kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0xf8 on isa0060/serio0).
Jan 13 17:34:34 calvin kernel: atkbd serio0: Use 'setkeycodes e078
<keycode>' to make it known.
Jan 13 17:34:35 calvin kernel: atkbd serio0: Unknown key released
(translated set 2, code 0xf8 on isa0060/serio0).
Jan 13 17:34:35 calvin kernel: atkbd serio0: Use 'setkeycodes e078
<keycode>' to make it known.

On working kernels, same logs shows the following lines:

Jan 13 22:55:59 calvin kernel: atkbd serio0: Unknown key pressed
(translated set 2, code 0xf8 on isa0060/serio0).
Jan 13 22:55:59 calvin kernel: atkbd serio0: Use 'setkeycodes e078
<keycode>' to make it known.
Jan 13 22:55:59 calvin NetworkManager[4823]: <info> WiFi now enabled
by radio killswitch
Jan 13 22:55:59 calvin NetworkManager[4823]: <info> (wlan0): bringing up device.
Jan 13 22:55:59 calvin kernel: iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
Jan 13 22:55:59 calvin kernel: iwlwifi 0000:03:00.0: Radio type=0x2-0x1-0x0
Jan 13 22:55:59 calvin kernel: atkbd serio0: Unknown key released
(translated set 2, code 0xf8 on isa0060/serio0).
Jan 13 22:55:59 calvin kernel: atkbd serio0: Use 'setkeycodes e078
<keycode>' to make it known.

I've tried to bisect the regression, and I've got this:

a57f7f9175b8ccbc9df83ac13860488913115de4 is the first bad commit
commit a57f7f9175b8ccbc9df83ac13860488913115de4
Author: Bob Moore <robert.moore@intel.com>
Date: Fri Aug 17 10:55:02 2012 +0800

ACPICA: Add Windows8/Server2012 string for _OSI method.
This change adds a new _OSI string, "Windows 2012" for both Windows 8
and Windows Server 2012.
>From Microsoft document "How to Identify the Windows Version in ACPI
by Using _OSI", July 13, 2012.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 55311ce2f9fed66501b06f93f67fa99b54d46e86
998889c21c3b68f8072ad131b643c592a4cbe423 M drivers

I've reverted this commit in 3.7.2 and now the rfkill button is
working just fine, so it seems the real culprit (well, I have no
knowledge about acpi so I say so only because reverting it fixes the
issue)
Please forgive me If I'm completely wrong  :)

--
Fabio
