Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbaELOtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:49:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:47445 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639AbaELOti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:49:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1035,1389772800"; 
   d="scan'208";a="430995335"
Message-ID: <5370E22E.8000304@linux.intel.com>
Date: Mon, 12 May 2014 18:01:02 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 03/10] usb: catch attempts to submit urbs with a vmalloc'd
 transfer buffer
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>	<1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com> <CAPcyv4hzw4wQ2ju3uaaHNfO+pemgWhgVdkE1Faiu3nRk3q276A@mail.gmail.com>
In-Reply-To: <CAPcyv4hzw4wQ2ju3uaaHNfO+pemgWhgVdkE1Faiu3nRk3q276A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 07:21 PM, Dan Williams wrote:
> On Thu, May 8, 2014 at 9:25 AM, Mathias Nyman
> <mathias.nyman@linux.intel.com> wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Save someone else the debug cycles of figuring out why a driver's
>> transfer request is failing or causing undefined system behavior.
>> Buffers submitted for dma must come from GFP allocated / DMA-able
>> memory.
>>
>> Return -EAGAIN matching the return value for dma_mapping_error() cases.
>>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>
> Thanks Mathias.
>
> One note, this was acked-by Alan here:
>
> http://marc.info/?l=linux-usb&m=139327920501989&w=2
>

Ah, Right

Greg, Alan, Should I resubmit this series with the added ACK for this patch?

-Mathias
