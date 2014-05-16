Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaEPNtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:49:11 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:49333 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368AbaEPNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:49:08 -0400
Date: Fri, 16 May 2014 15:49:04 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: serial console on rb532 disabled on boot (linux 3.15rc5)
Message-ID: <20140516134904.GW618@waldemar-brodkorb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linux hackers,

I am trying to bootup my Mikrotik RB532 board with the latest
kernel, but my serial console is disabled after boot:
..
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at MMIO 0x0 (irq = 104, base_baud = 12499875) is a
16550A
console [ttyS0] enabled
console [ttyS0] disabled

I used git bisect to find the problematic commit:
commit 5f5c9ae56c38942623f69c3e6dc6ec78e4da2076
Author: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Date:   Fri Feb 28 14:21:32 2014 +0100

    serial_core: Unregister console in uart_remove_one_port()
    
    If the serial port being removed is used as a console, it must
also be
    unregistered from the console subsystem using
unregister_console().
    
    uart_ops.release_port() will release resources (e.g. iounmap()
the serial
    port registers), causing a crash on subsequent kernel output if
the console
    is still registered.
    
    Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

After reverting the change, everything is fine.

I can provide a .config and dmesg if needed.

Thanks in advance
 Waldemar

