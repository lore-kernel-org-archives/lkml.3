Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaFWGHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:07:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15269 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaFWGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:07:45 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-46-53a7c42fdab4
Message-id: <53A7C42F.1060603@samsung.com>
Date: Mon, 23 Jun 2014 08:07:43 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: add claimed field in struct usb_ep
References: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
 <20140619150853.GG23782@saruman.home>
In-reply-to: <20140619150853.GG23782@saruman.home>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xK7r6R5YHG1ydwmMx62U7i8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rI7sHnsn7uG3aNvyypGj+M3tjN5fN4kF8ASxWWTkpqTWZZa
	pG+XwJXRuPw4Y8Fh1orzs+8xNzBuYuli5OSQEDCRON3wmxHCFpO4cG89WxcjF4eQwFJGiUvn
	LzBCOB8ZJbbv388OUsUroCWxf8kKNhCbRUBVYvntLawgNpuAjsSW7xPAJokKREjcazzMClEv
	KPFj8j2wbSICAhLrX1xiBxnKLNDFKLH+60kgh4NDWMBF4vgnEZAaIYFcieZ3C5lAbE4BI4nZ
	J86D7WIGmr+/dRqULS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz
	0vWS83M3MUIC+ssOxsXHrA4xCnAwKvHw3vBaHizEmlhWXJl7iFGCg1lJhLexASjEm5JYWZVa
	lB9fVJqTWnyIkYmDU6qBcc6yLAsHCaeGLYVXmuZNuXrwCM+j1ex7ZvRXWrj36S9tjf19a7HK
	7jaJmREaGi7zpjV3TjsY1nPsfPzS3esO1endnMWeG7Hyu010T7Ay99X7DRw+UoqP3d7dniKw
	N1Sw6NCq5v2ZL9dJ5et7eIm9u/uup1Fc5bPCPOan5vOZbO60FZaG+3V8U2Ipzkg01GIuKk4E
	AK6LyupGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 05:08 PM, Felipe Balbi wrote:
> On Mon, Jun 16, 2014 at 10:20:36AM +0200, Robert Baldyga wrote:
>> This field allows to mark ep as claimed in more clear way. Claiming
>> endpoint by setting driver_data to non-null value is leaky solution
>> and makes code unreadable.
> 
> how come ? How can it be unreadable ? how can it be leaky ?
> 

What if gadget will not assign any value to driver_data (just like
Gadget Zero do)? Endpoint will be seen as not used, and autoconfig will
return it more than one time. That's what I call leaky solution.

Information if endpoint is claimed or not is its internal state and
should not depend on assigning non-null value to driver_data field.
