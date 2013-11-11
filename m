Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3KKTIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:08:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:25181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3KKTIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:08:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,679,1378882800"; 
   d="scan'208";a="431520648"
Message-ID: <52812C2F.30202@linux.intel.com>
Date: Mon, 11 Nov 2013 11:12:47 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <1384102237-19784-1-git-send-email-mpn@google.com> <1384102237-19784-2-git-send-email-mpn@google.com> <5280567C.2060004@linux.intel.com> <xa1t8uwvyyia.fsf@mina86.com>
In-Reply-To: <xa1t8uwvyyia.fsf@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:21 AM, Michal Nazarewicz wrote:
> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
> to pad epout buffer to match above condition if quirk is found.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>   drivers/usb/gadget/f_fs.c | 23 +++++++++++++++++++----
>   1 file changed, 19 insertions(+), 4 deletions(-)
>
>> On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
>>> @@ -787,6 +788,13 @@ static ssize_t ffs_epfile_io(struct file *file,
>>>
>>>   	/* Allocate & copy */
>>>   	if (!halt) {
>>> +		/*
>>> +		 * Controller requires buffer size to be aligned to
>>> +		 * maxpacketsize of an out endpoint.
>>> +		 */
>>> +		data_len = read && gadget->quirk_ep_out_aligned_size ?
>>> +			usb_ep_align_maxpacketsize(ep->ep, len) : len;
>>> +
>>>   		data = kmalloc(len, GFP_KERNEL);
>
> On Mon, Nov 11 2013, David Cohen <david.a.cohen@linux.intel.com> wrote:
>> Shouldn't this kmalloc() allocate 'data_len' bytes, instead of 'len'?
>
> Yes, of coures.

Thanks. It looks fine. I'll test these patches now.

But the whole series became messy with too many amends. If you don't 
mind, I'll send a v5 of my patch set including my v4.1 patches + your 2
ones following the correct sequence.

Br, David Cohen
