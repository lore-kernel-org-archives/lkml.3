Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JBKe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:34:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33151 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3JBKeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:34:24 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-0e-524bf6ae2dc5
Message-id: <524BF6AD.8000908@samsung.com>
Date: Wed, 02 Oct 2013 12:34:21 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] USB: gadget: s3c-hsotg: add isochronous transfers
 support
References: <1380016036-20983-1-git-send-email-r.baldyga@samsung.com>
 <20131001144527.GX1476@radagast>
In-reply-to: <20131001144527.GX1476@radagast>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xa7rrvnkHGXQ2y1vMetnOYrFxxnpW
	i4P36y2aF69nszjb9Ibd4vKuOWwWi5a1MlusPXKX3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujLOLO9gLFgtVbLxwg6mB8RdfFyMnh4SAicS1CX3sELaYxIV769m6
	GLk4hASWMkqsnbGFCcL5yCgxrXcxE0gVr4CWxKLd6xlBbBYBVYn1r1uYQWw2AR2JLd8ngMVF
	BSIk/pzexwpRLyjxY/I9FhBbREBAYv2LS+wgQ5kFLjNKdF7aCTZUWCBYYs7DiWDNQgIZEqcP
	XAE7iVNAV2L5wsdgNrOAtcTKSdsYIWx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUomlqaXFCc
	lJ5rpFecmFtcmpeul5yfu4kREuZfdzAuPWZ1iFGAg1GJh1fioVeQEGtiWXFl7iFGCQ5mJRHe
	h1+9g4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzqoPmMjuHHmGc4lwnvxmj/sV8/bYNN7vleXW
	ublrevibfe/2rcr1P3xmrnLpi6eXgn9eOe/qWHB++44PN7/836+293NrvFnNRjVLzYpPEj0e
	6svfdx7baronP1P8wz/9M69i924MOrviUmDg2v/zvy4yds3NjFBMNbRRqrU9J+wh+KQv9d6m
	aCWW4oxEQy3mouJEAIpIUzNRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 04:45 PM, Felipe Balbi wrote:
Hello,
> Hi,
>
> On Tue, Sep 24, 2013 at 11:47:16AM +0200, Robert Baldyga wrote:
>> Hello,
>>
>> This is update for my proposal for isochronous transfers support in s3c-hsotg
>> driver. I've fixed issuses pointed by Bartlomiej Zolnierkiewicz. For more
>> information, please check the change log at the end of the mail.
>
> this shouldn't be part of commit log.
>
>> This patch adds isochronous transfer support. It adds few modifications:
>> - Modify s3c_hsotg_write_fifo() function. It actually calculates transfer
>>    size, taking into account Multi Count value, which indicates number of
>>    transactions per microframe.
>> - Fix s3c_hsotg_start_req() function by setting number of packets to Multi
>>    Count field in DIEPTSIZ register for isochronous endpoints.
>> - Fix s3c_hsotg_set_ep_maxpacket() function. Field wMaxPacketSize of endpoint
>>    descriptor is now splitted into maximum packet size value and number of
>>    additional transaction per microframe.
>> - Modify s3c_hsotg_epint() function. Some interrupts are ignored for
>>    isochronous endpoints, (e.g. INTknTXFEmpMsk) becouse isochronous request is
>>    always transfered in single transaction, which ends with XferCompl interrupt.
>>    Add Odd/Even microframe toggle to allow data transfering in each microframe.
>> - Fix s3c_hsotg_ep_enable() function by supporting isochronous endpoint type.
>
> you're doing way too many things in a single patch.

All these changes concerns to isochronous transfers support, and I
think they should not be splitted into number of patches. This entire
patch adds one compact functionality and it has no sense to put small
parts of this functionality to separated patches.

>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> Changelog:
>>
>> v2:
>> - moved bugfix affecting to the other features to separated patch
>> - changed conditions order in request length checking in s3c_hsotg_start_req
>>    function, as Bartlomiej Zolnierkiewicz suggested
>> - fixed typos
>>
>> v1: https://lkml.org/lkml/2013/9/23/72
>> - initial proposal
>
> changelog sould be after tearline (---) below.
>

Best regards
Robert Baldyga
Samsung R&D Institute Poland
