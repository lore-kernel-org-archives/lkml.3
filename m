Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaAXQ2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:28:09 -0500
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:43354 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAXQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:28:07 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 11:28:07 EST
Message-ID: <52E29310.1040600@saunalahti.fi>
Date: Fri, 24 Jan 2014 18:21:36 +0200
From: Joonas Saarinen <jza@saunalahti.fi>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: shawnn@chromium.org
Subject: Keyboard dead for a bunch of LG laptops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, people! There's still lingering an interesting regression where 
the internal keyboard of various older LG laptops is dead. It is tracked 
here:

https://bugzilla.kernel.org/show_bug.cgi?id=58991

Downstream:
https://bugzilla.redhat.com/show_bug.cgi?id=969550
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1243904
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1256776

Late last year, I personally did a git bisect on LG LW25 which ended up 
pointing at an atkbd patch:

be2d7e4233a4fe439125b825470020cef83407d5
Input: atkbd - fix multi-byte scancode handling on reconnect

Full description about that patch and some discussion:
https://groups.google.com/forum/#!topic/fa.linux.kernel/rUpZ8-HaQIM

Could it be that? The boot parameter i8042.dumbkbd=1 can be used to 
still make the keyboard functional. Of course that workaround leaves the 
keyboard a bit gimped (no lock LEDs, for example).

So, some questions:

1) What exactly happened? Is there something common with these LG 
machines' BIOS or keyboard controller firmware which causes the problem?

2) How could this happen? I thought the i8042 keyboard was one of the 
simplest devices in a PC. It's quite serious if it stops working like this.

3) Should something be done? Those are of course aging (Core 1 Duo era) 
machines, but I think Linux has always strived to work well with all 
sorts of hardware, old and new.


Joonas
