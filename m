Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaJPJgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:36:10 -0400
Received: from roy.gaast.net ([80.101.33.21]:40163 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaJPJgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:36:08 -0400
Message-ID: <543F9182.9000004@gaast.net>
Date: Thu, 16 Oct 2014 10:36:02 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <54347520.3050109@gaast.net> <543AA2FE.20105@gaast.net> <20141012204032.GA11171@amd> <9751497.0fL0kvsyX7@vostro.rjw.lan> <20141015111641.GC7792@gaast.net> <CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com> <CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com> <543F049F.5090605@gaast.net> <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 16-10-14 05:32, Yinghai Lu wrote:
>
> Can you please try attached patch? that should workaround the problem.
>
Sadly, no luck. (I do assume you meant me to use the patch against a 
clean 3.17 tree *without* yesterday's revert patch applied.) Back to a 
crash at/after the third resume:

[  372.502897] usb 3-1.1: reset high-speed USB device number 3 using 
ehci-pci
[  372.678765] usb 2-1.5: reset low-speed USB device number 3 using ehci-pci
[  373.398437] Clocksource tsc unstable (delta = -136457848 ns)
[  373.897503] Switched to clocksource hpet
[  373.897536] PM: resume of devices complete after 2143.535 msecs
[  373.898225] r8169 0000:07:00.0 eth0: link up
[  374.319311] Restarting tasks ... done.
(And then nothing.)

Interestingly I did see the "resume of devices" time grow on each resume 
again this time. I'll put the full dmesg dump in the same place like 
before: http://gaast.net/~wilmer/.lkml/

There's a lspci -vv dump there as well, as Bjorn asked for. I'll file a 
bug on bugzilla tonight.

> as some driver is using pci_enable_device in .resume instead of
> pci_renable_device....
>
Maybe this doesn't matter, but I could reproduce this issue even with no 
modules loaded at all (so barebone that I couldn't even mount my rootfs 
and had to do this testing in the initrd), so with only mainline kernel 
code running.


Thanks,

Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
