Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaE1HMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:12:31 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46732 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaE1HMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:12:30 -0400
Message-ID: <53858C5B.6030604@dev.rtsoft.ru>
Date: Wed, 28 May 2014 11:12:27 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mathias Nyman <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru> <20140527232715.GA26228@kroah.com>
In-Reply-To: <20140527232715.GA26228@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.05.2014 03:27, Greg Kroah-Hartman пишет:
> On Tue, May 27, 2014 at 08:56:42AM +0400, Nikita Yushchenko wrote:
>> This access causes hang on Freescale P2020DS board (that has OHCI
>> provided by ULI 1533 chip).
>>
>> Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
>> hardware and only later (in c6187597) was turned unconditional, and
>> c6187597 commit message again mentions only NVIDIA, I think it should be
>> safe to disable preserving OHCI_FMINTERVAL if device vendor is ULI.
> 
> Have you tested this?

With this applied, board boots ok.
With this not applied, board hangs on boot.

As for OHCI functionality - this was tested by other people here, but with
older kernel. Will retest myself with 3.15-rc as soon as get physical access
to board.

>> -	u32 fminterval;
>> +	u32 uninitialized_var(fminterval);
> 
> Why is this change needed?  Sounds like a compiler bug to me :)

  CC      drivers/usb/host/pci-quirks.o
In file included from include/linux/io.h:22:0,
                 from include/linux/pci.h:31,
                 from drivers/usb/host/pci-quirks.c:14:
drivers/usb/host/pci-quirks.c: In function 'quirk_usb_early_handoff':
/home/cge7/nikita/kernel-u/arch/powerpc/include/asm/io.h:180:1: warning: 'fminterval' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/usb/host/pci-quirks.c:574:6: note: 'fminterval' was declared here

gcc version 4.7.0 (MontaVista Linux G++ 4.7-140519214821)


Nikita
