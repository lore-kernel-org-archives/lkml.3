Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305Ab3BTSzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:55:13 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:33621 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933Ab3BTSzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:55:12 -0500
Date: Wed, 20 Feb 2013 19:54:47 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org, ciminaghi@gnudd.com
Subject: Re: tip/x86/amba
Message-ID: <20130220185447.GA13100@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <51251101.5070008@zytor.com>
References: <51251101.5070008@zytor.com>
  <20130220073554.GA10939@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I wonder what are the plans for the branch x86/amba, part of the tip
>> repository.  Of the 7 patches in that branch, 2 are already upstream
>> and the other 5 rebase perfectly (only conflicts are in the header
>> stanzas). This is the reverse log from next to my current working tree:
>> 
>>   0e7e31f DMA: PL330: use prefix in reg names to build under x86
>>   1e8486a watchdog: sp805_wdt depends on ARM
>>   6417077 mmc: Use the new <linux/sizes.h>
>>   52b9f4e drivers/amba: add support for a PCI bridge
>>   d8d2313 x86: add CONFIG_ARM_AMBA, selected by STA2X11

> We have been waiting for you to sort out the breakages and let us know
> that the problems has been resolved.  Sorry, [...]

Nothing to be sorry. Thanks for you patience.

> What are the upstream commits?

These are the ones in your branch:

  morgana% gitlog --reverse master..tip/x86/amba
  e4093bd DMA: PL330: use prefix in reg names to build under x86
  f5cfd23 pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
  f449ac1 watchdog: sp805_wdt depends on ARM
  ab189b1 mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep
  e61094e mmc: Use the new <linux/sizes.h>
  e7c1371 drivers/amba: add support for a PCI bridge
  5be5a01 x86: add CONFIG_ARM_AMBA, selected by STA2X11

Of those I see one in next (through the slave-dma/next branch):

  3a95b9f pl080.h: moved from arm/include/asm/hardware to include/linux/amba/

and one in master:

  4b85da0 ARM: 7596/1: mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep

For the other ones the conflicts are only in the #include
stanzas. Even with current master No error or warning is then when
enabling CONFIG_ARM_AMBA under x86, even replying y or m to every new
question.

(There are two sta2x11 warnings, unrelated to amba, that I'll post a
fix for RSN).

Shall I repost the current version, send privately or have them
somewhere for you to pull from?

Thanks
/alessandro
