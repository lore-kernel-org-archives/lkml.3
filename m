Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaL2Naz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:30:55 -0500
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:51744 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaL2Nay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:30:54 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2014 08:30:54 EST
Message-ID: <54A155C6.5050005@linicks.net>
Date: Mon, 29 Dec 2014 13:23:18 +0000
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [QUESTION] Unnamed syslog kernel logs
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello developers,

Not being very familiar with kernel debugging, I have a question about 
strange syslogs.

History:

I have been trying to tie-down a strange problem on my headless AMD64 
box - it occasionally just turns-off if just as if the power supply is 
cut.  It can happen anywhere between 2 months or 2 days - just intermittent.

Analysing logs (which when this occurs they do not report anything), I 
noticed this in syslog (typical):

Dec 28 09:37:19 sauron kernel: ACPI: PCI Interrupt Link [APCL] enabled 
at IRQ 22
Dec 28 09:37:19 sauron kernel: ACPI: PCI Interrupt Link [APC5] enabled 
at IRQ 16
Dec 28 09:37:19 sauron kernel: 1030
Dec 28 09:37:19 sauron kernel: 0200
Dec 28 09:37:19 sauron kernel: 0110
Dec 28 09:37:19 sauron kernel: 0111
Dec 28 09:37:19 sauron kernel: 0113
Dec 28 09:37:19 sauron kernel: 0362
Dec 28 09:37:19 sauron kernel: ACPI: PCI Interrupt Link [APSI] enabled 
at IRQ 21
Dec 28 09:37:19 sauron kernel: ACPI: PCI Interrupt Link [APSJ] enabled 
at IRQ 20

I don't understand what the middle lines are telling me here?

Anyway, today I took the machine down, and removed  ram a module (as I 
found it's sister slot was bad) and also the graphics card as I don't 
use it.

Now when I boot, these mysterious line have vanished from syslog:

ec 29 13:05:49 sauron kernel: ACPI: Enabled 1 GPEs in block 00 to 1F
Dec 29 13:05:49 sauron kernel: ACPI: PCI Interrupt Link [APCF] enabled 
at IRQ 23
Dec 29 13:05:49 sauron kernel: ACPI: PCI Interrupt Link [APCL] enabled 
at IRQ 22
Dec 29 13:05:49 sauron kernel: ACPI: PCI Interrupt Link [APSI] enabled 
at IRQ 21
Dec 29 13:05:49 sauron kernel: ACPI: PCI Interrupt Link [APSJ] enabled 
at IRQ 20
Dec 29 13:05:49 sauron kernel: ACPI: PCI Interrupt Link [APCH] enabled 
at IRQ 23

is all I get now in that section.

Was the kernel attempting to tell me something was bad with them funny 
unnamed lines?

Thanks for any help,

Regards,

Nick
-- 
"A bug in the code is worth two in the documentation."
http://linicks.net/
http://slackpi.linicks.net/
