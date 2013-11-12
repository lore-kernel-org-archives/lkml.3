Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3KLS0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:26:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:6322 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab3KLS0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:26:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="320296818"
Message-ID: <5282724F.10207@linux.intel.com>
Date: Tue, 12 Nov 2013 10:24:15 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Michal Nazarewicz <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <Pine.LNX.4.44L0.1311121046200.1200-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1311121046200.1200-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> IIUC, req->length should still be set to len, not to data_len.
>>
>> I misunderstood the first time I read it:
>> In order to avoid DWC3 to stall, we need to update req->length (this is
>> the most important fix). kmalloc() is updated too to prevent USB
>> controller to overflow buffer boundaries.
> 
> Here I disagree.
> 
> If the DWC3 hardware stalls, it is up to the DWC3 UDC driver to fix it.  
> Gadget drivers should not have to worry.  Most especially, gadget 
> drivers should not lie about a request length.
> 
> If the UDC driver decides to round up req->length before sending it to
> the hardware, that's okay.  But req->length should be set to len, not
> data_len.  And if the hardware receives more than len bytes of data,
> the UDC driver should set req->status to -EOVERFLOW.

Got your point. As long as buffer allocation has enough size, DWC3 is
able to fix itself. I'm fine with this approach too. But in this case I
will need to redo my DWC3 patch and my validation.

Br, David

> 
> Alan Stern
> 

