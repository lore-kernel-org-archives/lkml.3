Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaEHQcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:32:24 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44622 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaEHQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F70FC62@AcuExch.aculab.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
	<1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F70FC62@AcuExch.aculab.com>
Date: Thu, 8 May 2014 09:32:22 -0700
Message-ID: <CAPcyv4jeU-Xq9bJNuybF=tPPzR=ktthWbQCW+sBFd-1JkcZdFw@mail.gmail.com>
Subject: Re: [PATCH 03/10] usb: catch attempts to submit urbs with a vmalloc'd
 transfer buffer
From: Dan Williams <dan.j.williams@intel.com>
To: David Laight <David.Laight@aculab.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 9:22 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Mathias Nyman
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Save someone else the debug cycles of figuring out why a driver's
>> transfer request is failing or causing undefined system behavior.
>> Buffers submitted for dma must come from GFP allocated / DMA-able
>> memory.
>>
>> Return -EAGAIN matching the return value for dma_mapping_error() cases.
>
> Won't that just cause the request to be resubmitted a few clock
> cycles later?
> Surely you either need to error the request, or panic.

No, panic() is too drastic for this.

> In any case is this the right place for this sort of test?

Yes.

The system is already compromised because the driver is broken.  The
expectation is that this is a clue bat for a driver developer to fix
their code before it goes upstream.  I found this while debugging an
interaction with a new driver that was causing the xhci controller to
lock up.  Had this warning been there I likely never would have
received the xhci bug report.
