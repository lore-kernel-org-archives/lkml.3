Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaG1FxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:53:04 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48027 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1FxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:53:01 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-34-53d5e5395580
Message-id: <53D5E539.9030609@samsung.com>
Date: Mon, 28 Jul 2014 07:52:57 +0200
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
 <xa1ttx65ttca.fsf@mina86.com>
In-reply-to: <xa1ttx65ttca.fsf@mina86.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7qWT68GG7yfbmMx62U7i8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbLDjewurA7rF/7hp2j3V/XjF59G1Zxehx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mpr7P7IXHBWs2PX+MnMD42y+LkZODgkBE4nPi86zQthiEhfurWfr
	YuTiEBJYyiix/UgHK4TzkVHi5sxnQA4HB6+AlsTsp2EgDSwCqhIPfsxnAbHZBHQktnyfwAhi
	iwqESTz7dZAJxOYVEJT4MfkeWI2IgLnEib8rWEBmMgt0MUqs/3qSHSQhLOAmcfDvTKhlCxkl
	rk1sAktwAi07t+wDG8hiZgF1iSlTckHCzALyEpvXvGWewCgwC8mOWQhVs5BULWBkXsUomlqa
	XFCclJ5rqFecmFtcmpeul5yfu4kREuJfdjAuPmZ1iFGAg1GJhzfi5pVgIdbEsuLK3EOMEhzM
	SiK8nueuBgvxpiRWVqUW5ccXleakFh9iZOLglGpgtHj8ZN2O0yX2lx5dcD7zTOLl37IH8Z/O
	GmWunuqkI5z1T53lDAufWvntSxNOzTqXWNZf8e6YQFHW6f3NEhySDFtlDpzf1rF7xX97hXlb
	3vE8t2bQiF54fFqU3rkN+ozsPzOk7OsmT6r6yxh6O06u66TUxobYM5O+GTAbfVnb5fTIOHli
	RvjTf0osxRmJhlrMRcWJAKkfZB5PAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 04:18 PM, Michal Nazarewicz wrote:
> On Fri, Jul 25 2014, Robert Baldyga wrote:
>> This patch adds virtual endpoint address mapping to functionfs.
>>
>> So far endpoint addresses given by user through endpoint descriptors
>> were ignored, and replaced by physical endpoint addresses. Endpoint
>> address in wIndex field of setup requesti, addressed to endpoint, was
>> the physical endpoint address, and names of files in functionfs
>> directory was numered in order, and were the same as indexes of
>> ffs_epfile in epfile array. In result user has no way to indicate
>> which file in functionfs is associated with which particular
>> requested endpoint. He also didn't know which endpoint is recipient
>> of setup request.
> 
> Couldn't that be solved by simply providing the mapping to user space?

There would be only small differences in code (add mapping instead of
changing file names) so why would we not want do it in more intuitive way?

> 
>> There was also one more problem - if endpoint addresses in descriptors
>> were non-consecutive, there were created redundant files, which could
>> cause problems in kernel, when user tryed to read/write to them.
>> It was result of fact that maximum endpoint address was taken as
>> total number of endpoints in funciton.
> 
> This is kinda unrelated though.  I mean it's a separate bug.

Yes, but it can be fixed by the way, as a side effect, so there is no
sense (and probably no simple way) to move it into separate patch.

> 
>> This patch solves this problems by introducing virtual endpoint address
>> mapping. Now each function has separate endpoint address space. Numbers
>> of endpoint files in functionfs and addresses in setup requests are
>> mapped to addresses choosen by user in endpoint descriptors.
>>
>> It also introduces additional testing if desctiptors given by user are
>> consistent - if number of endpoints and their addresses in each speed
>> are the same.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/usb/gadget/f_fs.c | 78 +++++++++++++++++++++++++++++++++++++++--------
>>  drivers/usb/gadget/u_fs.h |  2 ++
>>  2 files changed, 68 insertions(+), 12 deletions(-)
> 

