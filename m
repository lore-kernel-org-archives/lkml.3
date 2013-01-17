Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab3AQCZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:25:47 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:2714 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758112Ab3AQCZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:25:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsGAG6Zu08Y1OVO/2dsb2JhbABEDoFtshaBCIIVAQEFOB4GHAEQCwsNCRYPCQMCAQIBERYeBg0BBwKHewENAadeiAIKGYELiHuLCYU7A4hCghaKQ4VPiiGCMFeBQQ
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="212748867"
Message-ID: <50F76135.8010708@gmail.com>
Date: Wed, 16 Jan 2013 21:25:57 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0 SeaMonkey/2.15
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andreas Mohr <andi@lisas.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
References: <Pine.LNX.4.44L0.1301160955450.1704-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301160955450.1704-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 15 Jan 2013, Woody Suwalski wrote:
>
>>> Another important change is that the EHCI driver is now split into two
>>> modules.  That can slow down loading and affect the timing.
>>>
>>> Alan Stern
>>>
>> My testcase is a live initramfs + squash root.
>> The boot logic is as stable as can be - unchanged since 2.6.2x kernels.
>> And it was working fine till 3.8-rc1.
>>
>> The modules are insmoded in a fixed order:
>> usb-common, usbcore, xhci-hcd, ehci-hcd, uhci-hcd, ohci-hcd, usbhid,
>> usb_storage,...
> But apparently you don't insmod ehci-pci.  That could cause problems,
> if your EHCI controller is PCI-based.
>
>> If all USB is built as modules - I get read errors from USB drives when
>> accessing squash image, boot fails.
> What read errors?  What is the cause of these errors?
>
>> If usb-common and usbcore are built in, system seems to crawl with a
>> very slow USB, but boots. That could be caused by timing between hcd
>> modules.
> Do have a dmesg log with timestamps so we can see where things go slow?
> I suggest enabling CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG.  You might
> even want CONFIG_USB_STORAGE_DEBUG, although that often logs too much
> information.
>
>> If usb-common, usbcore and ehci-hcd are built-in, all works OK like
>> "before 3.8".
> What about ehci-pci?
>
>
Alan, it took me 2 times re-reading the email to notice...
You were talking about ehci-pci, not ehci-hcd... Old assumptions die hard...
Yep, that was it.
Catch22 - I would have noticed new dependency if I could boot, but to 
boot I have had needed to notice the new dependency...

Case solved 8-)

Thanks, Woody

