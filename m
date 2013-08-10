Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3HJL0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 07:26:17 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.1.54]:58346 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab3HJL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 07:26:16 -0400
Message-ID: <52062353.9030800@rus.uni-stuttgart.de>
Date: Sat, 10 Aug 2013 13:26:11 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux@brodo.de, linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
References: <Pine.LNX.4.44L0.1308092103320.23882-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308092103320.23882-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

later... ok, bisected this even more. 2.6.31.14 kernel, old udev works 
fine. Then removed /etc/rcS.d/S02udev to be sure the 2.6.32 kernel would 
not pull the new udev. Rebuild 2.6.32.1 with *identical* kernel 
configuration, booted up, manually started the *old* udev as in 
2.6.31.14, and tried whether it worked.

Did not.

Thus: it is neither the udev configuration, nor the udev userspace 
program, nor the kernel configuration.

Something must be screwed in the kernel space. Which is interesting 
since 2.6.32.1 is actually older than 2.6.31.14 (but the older 2.6.31.6 
works, too, and younger 2.6.32.6 doesn't work either).

As said, configuration of 2.6.32.1 and 2.6.31.14 is the same.

Which modules are relevant for handling the communication with the 
device, and where would you suggest to start looking? I assume 
yenta_socket is one thing for the cartbus adapter, then we have ehci_hcd 
and ehci_pci. Do I assume correctly that we can rule out the ohci_hcd 
module since that is not involved? What about other usb modules? I would 
probably need a short recap on through which modules the user data flows 
before the write is triggered, and which modules are involved in the 
configuration of the NEC ehci host adapter.

Thanks,
	Thomas
