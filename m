Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaJ0KuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:50:11 -0400
Received: from roy.gaast.net ([80.101.33.21]:37575 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaJ0KuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:50:10 -0400
Message-ID: <544E235C.5010908@gaast.net>
Date: Mon, 27 Oct 2014 10:50:04 +0000
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <543F049F.5090605@gaast.net> <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com> <543F9182.9000004@gaast.net> <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com> <544033CF.3080104@gaast.net> <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com> <5442FE58.5020700@gaast.net> <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com> <5446D2D8.2090203@gaast.net> <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com> <20141022125354.GA3832@gaast.net> <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
In-Reply-To: <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yinghai,

Thanks again for your time!

I've applied your two patches, and as a wild guess also added pci=dump 
to my kernel cmdline though I guess that just gave me a boot-time dump - 
which mostly didn't make it into my dmesg.

I accidentally booted with no_console_suspend on the first run, which 
still caused no output at all on the failed resume. I'm including the 
output of that anyway, but also I have a run with that flag removed, and 
annoyingly the crash appears to happen before the dump during the crash 
finishes - while dumping info for this device, it seems:

04:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 
10) (prog-if 01 [Subtractive decode])

(More info in my lspci.txt)

Wondering what device that is exactly, I stumbled upon 
http://sourceforge.net/p/linux1394/mailman/message/29755048/ where 
someone describes it as a "cheap and crappy PCI bridge". More and more I 
wonder if I should just buy a new motherboard - sadly this one wasn't 
even that cheap. :-( Though I don't know if the output stopping while 
dumping output for this device means that it is the culprit, is printk() 
to the serial console in any way blocking/buffered?

Anyway, dumps are in:

http://gaast.net/~wilmer/.lkml/bad3.17-pcidumps-no_console_suspend.txt
http://gaast.net/~wilmer/.lkml/bad3.17-pcidumps.txt


Cheers,

Wilmer van der Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
