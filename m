Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaG2GMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:12:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27606 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaG2GMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:12:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-a9-53d73b52580c
Message-id: <53D73B52.1070908@samsung.com>
Date: Tue, 29 Jul 2014 08:12:34 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 1/3] usb: gadget: f_fs: virtual address mapping
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
 <1406295363-26998-2-git-send-email-r.baldyga@samsung.com>
 <xa1ttx65ttca.fsf@mina86.com> <53D5E539.9030609@samsung.com>
 <xa1tk36xrde3.fsf@mina86.com> <53D6397F.50403@samsung.com>
 <xa1t7g2xqzjh.fsf@mina86.com>
In-reply-to: <xa1t7g2xqzjh.fsf@mina86.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7pB1teDDd7OV7aY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktFhxvYXVg99g/dw27x7o/r5g8+rasYvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGW8uf2Qr2MddcXBqTAPjHM4uRg4OCQETiR9zCrsYOYFMMYkL99az
	dTFycQgJLGWUOD17EjOE85FRovPaTzaQKl4BLYnvb/tYQWwWAVWJr5tXM4LYbAI6Elu+TwCz
	RQXCJJ79OsgEUS8o8WPyPRYQW0TAXOLE3xUsIEOZBboYJdZ/PckOkhAWcJM4+HcmK8S2uUwS
	y7o6wTo4gbZtvzOdHeRUZgF1iSlTckHCzALyEpvXvGWewCgwC8mOWQhVs5BULWBkXsUomlqa
	XFCclJ5rqFecmFtcmpeul5yfu4kREuBfdjAuPmZ1iFGAg1GJhzfi5pVgIdbEsuLK3EOMEhzM
	SiK869WuBwvxpiRWVqUW5ccXleakFh9iZOLglGpgXHNM/Pu1dyF+e5Nfq5dU6Rfuszo9P7Jg
	375NiX/533/bXeD9aHfTknkLj3252Lhs9aL3E6f8rBbyCbu11Y2dkUNja/evz/Os3xW+2MsW
	+npprH/S9/RZxzQWXJrmfEMlzGjG6znHbz9TXfR3sQML8+LngucFVv1bEyempPfy+YOaCXVl
	Jfd7jB4rsRRnJBpqMRcVJwIANGbMb04CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 05:21 PM, Michal Nazarewicz wrote:
> OK, I see, I misunderstood your change before.  So what you're saying is
> that now we have:
> 1. numbers user space provides in bEndpoindAddress,
> 2. physical addresses assigned when endpoint is configured, and
> 3. numbers for file names which go sequentially;
> and what you want is to change the code so that 1 and 3 are the same.
> 
> Yes, I agree that would be better, and it was quite an omission on my
> part that I did not implement it that way, but at this point, I would
> argue that breaking backwards compatibility is not really worth it.

Code of examples still works after this changes. We can also assume that
the vast majority of users numbered endpoints sequentially. So there is
very little part of cases when API change can break the function daemon.

Eventually we can add new flag to user descriptors which turns on files
naming convention change (maybe it could be merged with my another patch
https://lkml.org/lkml/2014/7/25/297).

And there is another one change - when endpoint is recipient of setup
request, the physical endpoint address is translated into address chosen
by user in ep descriptor. It also affects on user space API, and
probably should be switched with the user flag.

I can try to move fixes which do not affect on user space API into
separate patch, and then prepare another one, which will add new API
features in case of user flag selection.
