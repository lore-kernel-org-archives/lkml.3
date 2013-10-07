Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3JGCl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 22:41:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60008 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3JGCl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 22:41:56 -0400
MIME-Version: 1.0
In-Reply-To: <5251DDDA.3070606@cogentembedded.com>
References: <1380925821-12848-1-git-send-email-david.a.cohen@linux.intel.com>
	<5251DDDA.3070606@cogentembedded.com>
Date: Sun, 6 Oct 2013 19:41:54 -0700
Message-ID: <CAPqfFkC_abmXpNwmrJiSNXX3C0cmDk5QgJRzbEdPvMei3_B6QQ@mail.gmail.com>
Subject: Re: [PATCH v2] usb: g_ffs: fix compilation warning
From: David Cohen <dacohen@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>, gregkh@linuxfoundation.org,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

(replying from my personal e-mail)

On Sun, Oct 6, 2013 at 3:02 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
> Hello.
>
> On 05-10-2013 0:30, David Cohen wrote:
>
>> If USB_FUNCTIONFS is selected without USB_FUNCTIONFS_ETH and
>> USB_FUNCTIONFS_RNIS, u_ether.h won't be included and then
>> USB_ETHERNET_MODULE_PARAMAETERS macro won't be available causing the
>> following warning compilation:
>
>
>> drivers/usb/gadget/g_ffs.c:81:1: warning: data definition has no type or
>> storage class [enabled by default]
>> drivers/usb/gadget/g_ffs.c:81:1: warning: type defaults to ‘int’ in
>> declaration of ‘USB_ETHERNET_MODULE_PARAMETERS’ [-Wimplicit-int]
>> drivers/usb/gadget/g_ffs.c:81:1: warning: function declaration isn’t a
>> prototype [-Wstrict-prototypes]
>
>
>> This patch fixes the warning by making USB_ETHERNET_MODULE_PARAMETERS to
>> be used iff u_ether.h is included, otherwise it is not needed.
>
>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>   drivers/usb/gadget/g_ffs.c | 2 ++
>>   1 file changed, 2 insertions(+)
>
>
>> diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
>> index 5327c82..2344efe 100644
>> --- a/drivers/usb/gadget/g_ffs.c
>> +++ b/drivers/usb/gadget/g_ffs.c
>> @@ -76,7 +76,9 @@ struct gfs_ffs_obj {
>>
>>   USB_GADGET_COMPOSITE_OPTIONS();
>>
>> +#if defined CONFIG_USB_FUNCTIONFS_ETH || defined CONFIG_USB_FUNCTIONFS_RNDIS
>
>
>    I thought the 'defined' operator requires ()?

I though the same. But I copied this line from this same file when
it's deciding whether to include u_ether.h or not.

BR, David Cohen
