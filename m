Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaJSKs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:48:59 -0400
Received: from roy.gaast.net ([80.101.33.21]:34486 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaJSKs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:48:57 -0400
Message-ID: <54439715.2060903@gaast.net>
Date: Sun, 19 Oct 2014 11:48:53 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <54347520.3050109@gaast.net> <543AA2FE.20105@gaast.net> <20141012204032.GA11171@amd> <9751497.0fL0kvsyX7@vostro.rjw.lan> <20141015111641.GC7792@gaast.net> <CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com> <CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com> <543F049F.5090605@gaast.net> <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com> <543F9182.9000004@gaast.net> <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com> <544033CF.3080104@gaast.net> <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com> <5442FE58.5020700@gaast.net> <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
In-Reply-To: <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 19-10-14 05:29, Yinghai Lu wrote:
>
> Please try to "debug ignore_loglevel no_console_suspend".
>
Same thing. :-(

[   72.572354] Restarting tasks ... done.
[   72.576554] PM: calling nb rcu_pm_notify+0x0/0x60
[   72.581277] PM: ... nb rcu_pm_notify+0x0/0x60 done
[   72.586115] PM: calling nb cpu_hotplug_pm_callback+0x0/0x50
[   72.591692] PM: ... nb cpu_hotplug_pm_callback+0x0/0x50 done
[   72.597345] PM: calling nb fw_pm_notify+0x0/0x150
[   72.602047] PM: ... nb fw_pm_notify+0x0/0x150 done
[   72.606839] PM: calling nb bsp_pm_callback+0x0/0x50
[   72.611711] PM: ... nb bsp_pm_callback+0x0/0x50 done
[   73.382175] r8169 0000:07:00.0 eth0: link up
[   78.857526] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   79.025718] ata3.00: configured for UDMA/133
[   81.379533] ata4: softreset failed (device not ready)
[   82.623212] PM: Syncing filesystems ... done.
[   82.661564] PM: Preparing system for mem sleep
[   82.669405] Freezing user space processes ... (elapsed 0.001 seconds) 
done.
[   82.677729] Freezing remaining freezable tasks ... (elapsed 0.001 
seconds) done.
[   82.686338] PM: Entering mem sleep

And nothing related to resume. :-(

Is there any point of me retrying with the initcall_debug flag but 
without your patch?

Looking at your patch again, it seems pretty mad that this would cause 
such a big difference. Overnight I remembered how my machine has TSC 
issues at the time this bug shows, so I tried setting hpet as the 
clocksource. (hpet=force on the cmdline did not seem to have that effect 
so I used sysfs instead) No effect either.

I need to go now, can experiment a little more tonight.


Thanks,

Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
