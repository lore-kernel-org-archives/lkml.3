Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaARSeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 13:34:23 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52739 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaARSeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 13:34:20 -0500
Message-ID: <52DAC928.2070002@gmail.com>
Date: Sat, 18 Jan 2014 10:34:16 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 06:34 AM, David Laight wrote:
> From: walt
>> Oy, Sarah! ;)  I put the ASMedia adapter in my older amd64 machine, and, well,
>> the stupid thing Just Works(TM) with kernel 3.12.7!  (Yes, with the same disk
>> docking station, too.)
>>
>> I can't believe the adapter works perfectly in a different computer.  Have you
>> seen this kind of thing before?
> 
> Could be a horrid timing race between the cpu and xchi controller.
> If the cpu manages to write a NOP or LINK TRB for a following transfer
> before the controller polls the next entry (after raising the IRQ)
> then the controller might process the LINK and then get confused
> when it can't process the linked-to TRB.
> This might not sound likely, but PCIe has significant latency.

 
> Can you try the patch I posted that stops the ownership on LINK TRBs
> being changed before that on the linked-to TRB?

David, the patch doesn't apply cleanly to any 3.12.x sources I can find,
including the latest git from Linus.  Half of the hunks fail.  Could you
create a fresh patch against vanilla 3.12.8 so I can test it? Or point me
to the correct kernel sources, perhaps.

Thanks.


