Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032Ab3DPJ5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:57:12 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:43014 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934696Ab3DPJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:57:10 -0400
Subject: Re: Cannot add new efi boot entry
From: joeyli <jlee@suse.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: matthew.garrett@nebula.com, matt.fleming@intel.com, cbouatmailru@gmail.com,
        ccross@android.com, keescook@chromium.org,
        Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <516B1ED3.9040900@suse.cz>
References: <516B1ED3.9040900@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Apr 2013 17:56:08 +0800
Message-ID: <1366106168.23707.9.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, 

於 日，2013-04-14 於 23:25 +0200，Jiri Slaby 提到：
> Hi,
> 
> after update to 3.8, every update of the kernel ends up in an unbootable
> machine. It is due to the following commit:
> commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
> Author: Matthew Garrett <matthew.garrett@nebula.com>
> Date:   Sat Mar 2 19:40:17 2013 -0500
> 
>     efi: be more paranoid about available space when creating variables
> 
> efibootmgr which tries to add an entry and silently fails when writing
> to /sys/firmware/efi/vars/new_var with -ENOSPC.
> 
> There are many entries in there:
> # efibootmgr
> BootCurrent: 000D
> Timeout: 0 seconds
> BootOrder:
> 0018,0000,0001,0002,0003,0007,0008,0009,000A,000B,000C,000D,000E,000F,0010,0011,0012
> Boot0000  Setup
> Boot0001  Boot Menu
> Boot0002  Diagnostic Splash Screen
> Boot0003  Lenovo Diagnostics
> Boot0004  Startup Interrupt Menu
> Boot0005  ME Configuration Menu
> Boot0006  Rescue and Recovery
> Boot0007* USB CD
> Boot0008* USB FDD
> Boot0009* ATAPI CD0
> Boot000A* ATA HDD0
> Boot000B* ATA HDD1
> Boot000C* ATA HDD2
> Boot000D* USB HDD
> Boot000E* PCI LAN
> Boot000F* ATAPI CD1
> Boot0010  Other CD
> Boot0011* ATA HDD3
> Boot0012  Other HDD
> Boot0013* IDER BOOT CDROM
> Boot0014* IDER BOOT Floppy
> Boot0015* ATA HDD
> Boot0016* ATAPI CD:
> Boot0017* PCI LAN
> Boot0018* Linux
> 
> 
> Remaining size is about 20k, added entry size is hundreds bytes, store
> size is 64k.
> 
> Obviously lowering the limitation from 1/2 to 1/4 fixes the problem for
> me because it always worked on my setup to store a new entry...
> 
> Any ideas how to overcome that? It would be better to blacklist bad
> machines rather than whitelist good ones, right?
> 
> thanks,

I think I just got the same situation on my side with Acer machine. I am
trying Matthew's new patchset hope can avoid this situation:

https://lkml.org/lkml/2013/4/15/473


Thanks a  lot!
Joey Lee



