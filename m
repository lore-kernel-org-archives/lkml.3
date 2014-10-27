Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaJ0WW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:22:27 -0400
Received: from roy.gaast.net ([80.101.33.21]:41272 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaJ0WW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:22:26 -0400
Message-ID: <544EC59D.9080303@gaast.net>
Date: Mon, 27 Oct 2014 22:22:21 +0000
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <543F049F.5090605@gaast.net> <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com> <543F9182.9000004@gaast.net> <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com> <544033CF.3080104@gaast.net> <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com> <5442FE58.5020700@gaast.net> <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com> <5446D2D8.2090203@gaast.net> <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com> <20141022125354.GA3832@gaast.net> <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com> <544E235C.5010908@gaast.net> <CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
In-Reply-To: <CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 27-10-14 18:23, Yinghai Lu wrote:
>
> 04:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892
>
> So that ITE will not work after suspend/resume?
>
Even after the first one already, you mean?

Honestly, I don't really know what its purpose is, and it doesn't have 
any child nodes in the PCI tree from what I can tell. Possibly because I 
don't have any PCI cards in the machine, just a PCIe video card - 
assuming this is a PCI bridge taking care of legacy PCI plugin cards?

> Please apply 4 attached patches and try to remove the device like
>
> echo 1 > /sys/bus/pci/devices/0000\:04\:00.0/remove
> echo 1 > /sys/bus/pci/devices/0000\:00\:1c.3/pcie_link_disable
>
> before suspend/resume test.
>
That worked! Resumed properly now.

Full log in http://gaast.net/~wilmer/.lkml/good3.17.txt . Including the 
PCI dump at boot time, where that device doesn't dump just ff's.


Wilmer van der Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
