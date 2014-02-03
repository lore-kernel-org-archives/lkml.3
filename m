Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaBCPeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:34:03 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60769 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaBCPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:34:01 -0500
MIME-Version: 1.0
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Mon, 3 Feb 2014 17:33:39 +0200
Message-ID: <CA+QCeVQC-iqPqmvKK6D6YL=4do8yB3ez3n=L2Jj9_2qu5FVLbQ@mail.gmail.com>
Subject: SysRQ via serial console doesn't work for VMWare guests
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tried to utilize SysRQ via serial console in VMWare environment:
>From what I've seen RS-232 Break + <KEY> just doesn't work for 3.13.1
for VMWare guests:

[root@dca-eccs-sbx-db2 ~]# cat /proc/tty/driver/serial
serinfo:1.0 driver revision:
0: uart:16550A port:000003F8 irq:4 tx:10034 rx:1 RTS|CTS|DTR|DSR|CD
1: uart:16550A port:000002F8 irq:3 tx:0 rx:0 CTS|DSR|CD
2: uart:unknown port:000003E8 irq:4
3: uart:unknown port:000002E8 irq:3
[root@dca-eccs-sbx-db2 ~]#

Kernel console messages are visible just fine. But SysRQ over serial
is not working.

What I have tried to issue break is:
1) screen Control-a b (first VM serial port connected to second VM serial port))
2) minicom Ctrl-a f (first VM serial port connected to second VM serial port)
3) telnet - ctrl + ] "send brk" from virtual serial port concentrator.

All three above seem like really sending break, though any SysRQ
command neither after 5 seconds as stated in documentation nor
immediately is producing any result.

Have anyone succeed to use SysRQ over serial with WMWare guests?

I have already opened Red Hat case for that. Their responce was:

"...I think this only works on real physical serial ports.  From the kernel
docs:
    On the serial console (PC style standard serial ports only) -
           You send a BREAK, then within 5 seconds a command key.
           Sending BREAK twice is interpreted as a normal BREAK.
https://www.kernel.org/doc/Documentation/sysrq.txt

An RS-232 BREAK is a period of no electricity on the wire.  That's
rather difficult to do in a software-only virtual environment..."

I have found that explanation a bit strange.
