Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaFRU7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:59:40 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:35230 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaFRU7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140618181439.GA8161@kroah.com>
References: <1403113980-7587-1-git-send-email-xerofoify@gmail.com>
	<20140618181439.GA8161@kroah.com>
Date: Wed, 18 Jun 2014 16:59:38 -0400
Message-ID: <CAPDOMVjz8jKwn=MSC0PHZE=13izz0nqZkfmr8aajCD_vMUxsrQ@mail.gmail.com>
Subject: Re: [PATCH] Checks for Null return of skb_alloc in function fw_download_code
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, ben@decadent.org.uk, lisa@xenapiadmin.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So sorry Greg,
I pulled the git in this morning for kernel-3.16-r2 ,I will resend the
patch from the clean tree.
I will also fix the tabs.'
Sorry :( Nick

On Wed, Jun 18, 2014 at 2:14 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 18, 2014 at 01:53:00PM -0400, Nicholas Krause wrote:
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> index 11e915e..fde17ff 100644
>> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> @@ -62,12 +62,15 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>>
>>               skb  = dev_alloc_skb(frag_length + 4);
>> +             if (!skb) {
>> +                             rt_status = false;
>> +                             return rt_status;
>> +
>> +             }
>
> Why 2 tabs for indentation?  Does that look correct?
>
>>               memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>>               tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>>               tcb_desc->queue_index = TXCMD_QUEUE;
>>               tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
>>               tcb_desc->bLastIniPkt = bLastIniPkt;
>> -             }
>>
>>               seg_ptr = skb->data;
>>               for (i = 0; i < frag_length; i += 4) {
>
> Also, this patch still fails to apply, what tree did you make it
> against?  A "clean" 3.16-rc1 tree, or your own tree with other changes
> in it?
>
> greg k-h
