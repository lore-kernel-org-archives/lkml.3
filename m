Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaDNPpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:45:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:35719 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaDNPpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:45:12 -0400
Date: Mon, 14 Apr 2014 17:44:58 +0200
Message-ID: <20140414174458.Horde.ieyRX8PcZ0lg3nY1QFE2DA4@webmail.your-server.de>
From: stefani@seibold.net
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        sarah.a.sharp@linux.intel.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
References: <1397416959.1555.30.camel@vger.seibold.net>
 <1397468521.9258.28.camel@pasglop>
In-Reply-To: <1397468521.9258.28.camel@pasglop>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.7)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Benjamin Herrenschmidt <benh@au1.ibm.com>:

> On Sun, 2014-04-13 at 21:22 +0200, Stefani Seibold wrote:
>> When executing a kexec kernel on a PowerPC board the new started kernel
>> will not find already enumerated USB devices due a missing reset on the
>> USB bus.
>>
>> As a work around a
>>
>> echo 1 >/sys/bus/pci/drivers/[ex]hci-pci/BUS-ADDRESS-OF-THE-HCD/reset
>>
>> will solve this. But this is far from beauty.
>>
>> My latest kernel without this issue was for EHCI kernel 2.6.39 and for
>> XHCI kernel 3.4, but i have no idea when exactly this behavior was
>> introduced.
>>
>> For X86 all is fine.
>
> I don't know about EHCI specifically but this is a known issue with
> XHCI, I observe similar issues on other powerpc platforms (servers)
> and this isn't architecture specific (looks more like actualy xhc
> implementation specific).
>
> Thadeu Cascardo (on CC) has been the one investigating that on our side,
> he might have more to add including patches.
>

I have now a kernel 3.14 dmesg log of the problem. After a kexec the  
kexeced 3.14 kernel shows:

[    1.170029] xhci_hcd 0001:03:00.0: xHCI Host Controller
[    1.175306] xhci_hcd 0001:03:00.0: new USB bus registered, assigned  
bus number 1
[    1.212561] xhci_hcd 0001:03:00.0: Host not halted after 16000  
microseconds.
[    1.219621] xhci_hcd 0001:03:00.0: can't setup: -110
[    1.224597] xhci_hcd 0001:03:00.0: USB bus 1 deregistered
[    1.230021] xhci_hcd 0001:03:00.0: init 0001:03:00.0 fail, -110
[    1.235955] xhci_hcd: probe of 0001:03:00.0 failed with error -110

Any idea?

- Stefani


