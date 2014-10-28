Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaJ1XeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:34:24 -0400
Received: from roy.gaast.net ([80.101.33.21]:49541 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbaJ1XeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:34:23 -0400
Message-ID: <545027F9.1040703@gaast.net>
Date: Tue, 28 Oct 2014 23:34:17 +0000
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
References: <543F049F.5090605@gaast.net> <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com> <543F9182.9000004@gaast.net> <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com> <544033CF.3080104@gaast.net> <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com> <5442FE58.5020700@gaast.net> <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com> <5446D2D8.2090203@gaast.net> <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com> <20141022125354.GA3832@gaast.net> <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com> <544E235C.5010908@gaast.net> <CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com> <544EC59D.9080303@gaast.net> <CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com> <544EDD40.1040107@gaast.net> <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
In-Reply-To: <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 28-10-14 01:12, Yinghai Lu wrote:
> lspci -vvxxxx -s 00:1c.3
> lspci -vvxxxx -s 04:00.0
> before reverting enable bridge early patch

http://gaast.net/~wilmer/.lkml/lspcixx-nopatch.txt (So that's 3.17 + 
your revert patch)

> and after reverting on 3.17+?
>
http://gaast.net/~wilmer/.lkml/lspcixx-patched.txt

plain 3.17.

I've run the commands twice, once before and once after a single 
suspend+resume cycle. Small difference and only before that cycle:

ruby:~/crashit# diff -u lspcixx-*
--- lspcixx-nopatch.txt 2014-10-28 23:26:08.679690828 +0000
+++ lspcixx-patched.txt 2014-10-28 23:10:05.391896757 +0000
@@ -92,10 +92,10 @@
  2f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  310: 00 00 00 00 1b 36 3a 74 00 00 14 14 31 17 42 00
-320: 5b 60 09 00 00 20 00 0a 08 10 b8 04 07 00 d5 0c
+320: 5b 60 09 00 00 20 00 0a 90 10 b8 04 8f 00 5d 0d
  330: 16 00 00 28 bc b5 bc 4a 00 00 00 00 74 4c 85 00
-340: 33 03 33 00 64 03 3f 00 30 00 0c 00 f8 07 d5 00
-350: fe 07 dd 00 01 00 08 00 00 00 00 00 00 00 00 00
+340: 33 03 33 00 64 03 3f 00 30 00 0c 00 f8 07 5d 00
+350: fe 07 65 00 01 00 08 00 00 00 00 00 00 00 00 00
  360: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  370: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

(Diff is in the Intel device, not the ITE one.)


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
