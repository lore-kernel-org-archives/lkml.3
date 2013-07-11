Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3GKTw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:52:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:3296 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab3GKTwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:52:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,647,1367996400"; 
   d="scan'208";a="267111829"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Shuah Khan <shuah.kh@samsung.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: RE: [Intel-gift] Linux 3.10-rc7
Thread-Topic: [Intel-gift] Linux 3.10-rc7
Thread-Index: Ac59gJi9domNTZLbT4OS9A/79ZioNQA7ePWA
Date: Thu, 11 Jul 2013 19:52:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028E6200@HASMSX106.ger.corp.intel.com>
References: <5B8DA87D05A7694D9FA63FD143655C1B028E5075@HASMSX106.ger.corp.intel.com>
 <B8EFE96D1287C24090BAD9D858E15E617382FC@sisaex02sj>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E617382FC@sisaex02sj>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't see mei_me_pci_suspend() calling mei_disable_interrupts() and
> pci_disable_msi().

Suspend calls mei_reset with request for disabling interrupts  
I'm pretty sure I do free_irq and I do disable_msi in the suspend (Hope we are looking at the same code)

 I don't see a call to mei_enable_interrupts() from
> mei_me_pci_resume(). I don't think mei_enable_interrupts() is used
> anywhere. pci_dev_msi_enabled() enables the interrupts in
> mei_me_pci_resume() looks like.

Again here we call mei_reset with request of enabling the interrupts 

> 
> However, I did notice one thing, if pci_dev_msi_enabled() returns false,
> request_threaded_irq() is called  with IRQF_SHARED. Again might just be
> fine, it leads me to the next question.
>

Is the MSI disabled on  your platform? 
 
> mei_me_pci_suspend() has code that runs after disabling interrupts. Does
> this need to be split into suspend() and suspend_noirq() ops, since the IRQ
> could be shared?

If you don't have msi 
I think usually it is shared with some USB device, but I haven't seen that in my code I will check again.
Would other resume block the interrupt line?
 
> It is a possibility if pci_enable_msi() takes longer in resume path and
> pci_dev_msi_enabled() returns false, then IRQF_SHARED is requested.
> 
> Don't know if this helpful, but I thought I would ask just in case, it helps you
> think of something you didn't before. Please let me know if you need help
> gathering data from my system.

Thanks for ideas I will check that points.

Thanks
Tomas

> -- Shuah
> 
> Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research
> America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
