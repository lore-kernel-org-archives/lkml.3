Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3BWGOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 01:14:38 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:48645 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab3BWGOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 01:14:36 -0500
MIME-Version: 1.0
In-Reply-To: <5126B617.6010405@canonical.com>
References: <511D0BCC.9070208@canonical.com>
	<20130215073210.GM7867@spo001.leaseweb.com>
	<511E4C43.7080403@canonical.com>
	<CAHh0gOgeWn5QaDGzgstft7AoQsKdoZ+4Utp8iQxxSCO0q=cZ-Q@mail.gmail.com>
	<51219C56.8060504@canonical.com>
	<CAGHUO12ROdB4=LVyod7+RaoONHfMfiyLAj73cC+BczLGDG+i+Q@mail.gmail.com>
	<CAHh0gOgiSjTYvEzim-7+yEhU74c5PVV=2ScTnaJ15SPY=y-WqA@mail.gmail.com>
	<5126B617.6010405@canonical.com>
Date: Sat, 23 Feb 2013 15:14:32 +0900
Message-ID: <CAHh0gOi3b+CKMVLwQQxJ+n2XOseirJ6cFhLOVX_BboN9rzM5Jw@mail.gmail.com>
Subject: Re: [v3.8 Regression] watchdog: sp5100_tco: Add SB8x0 chipset support
From: Tanaka Takahisa <mc74hc00@gmail.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Joseph Salisbury <josephtsalisbury@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

Thank you for testing!
I will submit this patch to the linux-watchdog community after adding
commit log to patch.

2013/2/22 Joseph Salisbury <joseph.salisbury@canonical.com>:
> The I/O data can be seen at:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835/+attachment/3540738/+files/iomem.txt

In the case of SP5100 and SB7x0 chipset, the sp5100_tco driver
overwrites a free resource I/O memory address obtained by
allocate_resource() to the MMIO address registers for watchdog timer.
In the case of M3A78-CM, the sp5100_tco driver was using 0xfed45000 as
a MMIO address. Since 0xfed45000 is the free I/O memory resource
address, this is the expected behavior.

  [   18.852540] sp5100_tco: Using 0xfed45000 for watchdog MMIO address

However, Rewriting the MMIO address registers for the watchdog timer
must have generated the problem. I think that the problem has occurred
with the chipset or the BIOS layer. So, It's difficult for me to
investigate the problem, and the problem is critical. Thus, I decided
to delete the concerned codes.


Regards,
Takahisa
