Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab3LFURF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:17:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:61968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792Ab3LFURC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:17:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="445934657"
Message-ID: <52A23040.2000605@linux.intel.com>
Date: Fri, 06 Dec 2013 12:14:56 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Michal Nazarewicz <mina86@mina86.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-3-git-send-email-david.a.cohen@linux.intel.com> <xa1tzjpawl1x.fsf@mina86.com> <5281706F.5050507@linux.intel.com> <xa1t1u2ln5kr.fsf@mina86.com> <20131206201337.GD3889@saruman.home>
In-Reply-To: <20131206201337.GD3889@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 12:13 PM, Felipe Balbi wrote:
> On Tue, Nov 12, 2013 at 01:54:28PM +0100, Michal Nazarewicz wrote:
>> On Tue, Nov 12 2013, David Cohen wrote:
>>> On 11/11/2013 03:55 PM, Michal Nazarewicz wrote:
>>>> Come to think of it, perhaps even better helper would be:
>>>>
>>>> static inline size_t usb_ep_align_maybe(
>>>> 	struct usb_gadget *gadget, struct usb_ep *ep, size_t len) {
>>>> 	return gadget->quir_ep_out_aligned_size ?
>>>> 		round_up(len, (size_t)ep->desc->wMaxPacketSize) : len;
>>>> }
>>>
>>> The CPU time to check unsigned:1 and possibly jump is about the same as
>>> round_up() itself. For readability matters, we can round_up() directly.
>>
>> I was proposing to have this function and than not have functions check
>> for the flag.  I.e. instead of
>>
>> 	if (gadget->quirk_ep_out_aligned_size)
>> 		len = usb_ep_align_maxpacketsize(ep, len);
>>
>> the code would just be:
>>
>> 	len = usb_ep_align_maybe(gadget, ep, len);
> 
> that looks very good to me, do we have a version with that already ?

Nope. But as soon as soon as you finish the whole review, I can resend
new version with all changes at once.

Br, David
