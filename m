Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaC1UIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:08:39 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62964 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaC1UIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:08:37 -0400
MIME-Version: 1.0
Reply-To: daniel.mclellan@hotmail.com
Date: Fri, 28 Mar 2014 16:08:36 -0400
Message-ID: <CAEigmK-pY+9XF4V-KRZrbiO8GY5Fs6scE+Ehm1zc5T8V2RiB9g@mail.gmail.com>
Subject: eboot.c regression allows boot, from v3.7 on- no boot with UEFI, only
 legacy, bisect results
From: Daniel McLellan <daniel.mclellan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: matt.fleming@intel.com, mjg@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System: Hewlett-Packard product: HP EliteBook 2570p
CPU~Dual core Intel Core i7-3520M CPU (-HT-MCP-)
Kernel: 3.12.4-2-hplove x86_64 (64 bit) Desktop: Enlightenment 0.18.99.18202
Distro: Arch Linux


I believe this issue is common to only a few iterations of ivy bridge

https://bbs.archlinux.org/viewtopic.php?id=156670
https://bugs.archlinux.org/task/33745?project=1

I had been patching eboot.c to v3.7 with the attached
efi_hp_boot.patch, but due to the recent changes in eboot.c (in v3.13)
I decided to bisect, and identified the following:

# first bad commit: [dd5fc854de5fd37adfcef8a366cd21a55aa01d3d] EFI:
Stash ROMs if they're not in the PCI BAR

My next step is diffing the eboot.c from v3.13.

or would a better path be to check for ivy bridge?
