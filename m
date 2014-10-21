Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbaJUVkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:40:51 -0400
Received: from roy.gaast.net ([80.101.33.21]:53097 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458AbaJUVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:40:47 -0400
Message-ID: <5446D2D8.2090203@gaast.net>
Date: Tue, 21 Oct 2014 22:40:40 +0100
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

Sorry for the delay, finally poked at this again. It looks like the 
no_console_suspend flag was causing troubles, which I didn't really need 
anyway with logging going to my serial port.

This is what I get now on the failing resume:

[  112.879390] PM: resume of devices complete after 2239.905 msecs
[  112.880068] r8169 0000:07:00.0 eth0: link up
[  112.880078] Switched to clocksource hpet
[  116.069248] PM: Finishing wakeup.
[  116.072574] Restarting tasks ... done.
[  116.076664] PM: calling nb rcu_pm_notify+0x0/0x60
[  116.081439] PM: ... nb rcu_pm_notify+0x0/0x60 done
[  116.086267] PM: calling nb cpu_hotplug_pm_callback+0x0/0x50
[  116.088526] systemd[1]: Got notification message for unit 
systemd-journald.service
[  116.099442] PM: ... nb cpu_hotplug_pm_callback+0x0/0x50 done
[  116.105099] PM: calling nb fw_pm_notify+0x0/0x150
[  116.109812] PM: ... nb fw_pm_notify+0x0/0x150 done
[  116.114623] PM: calling nb bsp_pm_callback+0x0/0x50
[  116.119504] PM: ... nb bsp_pm_callback+0x0/0x50 done

And then nothing, and it's hung. Looks the same to me (apart from the 
tsc issues + hpet switch) as a successful resume:

[   95.499513] PM: resume of devices complete after 1240.115 msecs
[   96.368940] r8169 0000:07:00.0 eth0: link up
[   98.676455] PM: Finishing wakeup.
[   98.679765] Restarting tasks ... done.
[   98.683821] PM: calling nb rcu_pm_notify+0x0/0x60
[   98.688524] PM: ... nb rcu_pm_notify+0x0/0x60 done
[   98.692044] systemd[1]: Got notification message for unit 
systemd-journald.service
[   98.700897] PM: calling nb cpu_hotplug_pm_callback+0x0/0x50
[   98.706470] PM: ... nb cpu_hotplug_pm_callback+0x0/0x50 done
[   98.712132] PM: calling nb fw_pm_notify+0x0/0x150
[   98.716848] PM: ... nb fw_pm_notify+0x0/0x150 done
[   98.721644] PM: calling nb bsp_pm_callback+0x0/0x50
[   98.726536] PM: ... nb bsp_pm_callback+0x0/0x50 done

Full logs in http://gaast.net/~wilmer/.lkml/bad3.17-patched-megadebug.txt


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
