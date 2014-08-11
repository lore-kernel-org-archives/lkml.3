Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaHKSHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:07:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaHKSHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:07:42 -0400
Message-ID: <53E9066A.3030801@infradead.org>
Date: Mon, 11 Aug 2014 11:07:38 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lisa@xenapiadmin.com, Ben Hutchings <ben@decadent.org.uk>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Check against NULL in fw_download_code
References: <1407780151-4674-1-git-send-email-xerofoify@gmail.com> <CAPDOMVghgyQ72J6MS6uaWEeMFBvzDNmfoAS5Tbd7+XO_KgUmHg@mail.gmail.com>
In-Reply-To: <CAPDOMVghgyQ72J6MS6uaWEeMFBvzDNmfoAS5Tbd7+XO_KgUmHg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 11:04, Nick Krause wrote:
> On Mon, Aug 11, 2014 at 2:02 PM, Nicholas Krause <xerofoify@gmail.com> wrote:
>> I am fixing the bug entry , https://bugzilla.kernel.org/show_bug.cgi?id=60461.
>> This entry states that we are not checking the skb allocated in fw_download_code
>> and after checking I fixed it to check for the NULL value before using the allocate
>> skb.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 14 ++++++++------
>>  1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> index 1a95d1f..0a4c926 100644
>> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> @@ -60,13 +60,15 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>>
>>                 }
>>
>> -               skb  = dev_alloc_skb(frag_length + 4);
>> -               memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>> -               tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>> -               tcb_desc->queue_index = TXCMD_QUEUE;
>> -               tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
>> -               tcb_desc->bLastIniPkt = bLastIniPkt;
>>
>> +               skb  = dev_alloc_skb(frag_length + 4);
>> +               if (skb) {
>> +                       memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>> +                       tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>> +                       tcb_desc->queue_index = TXCMD_QUEUE;
>> +                       tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
>> +                       tcb_desc->bLastIniPkt = bLastIniPkt;
>> +               }

and what happens here (below) if skb is NULL?

>>                 seg_ptr = skb->data;
>>                 for (i = 0; i < frag_length; i += 4) {
>>                         *seg_ptr++ = ((i+0) < frag_length) ?
>> --
>> 1.9.1
>>
> And I did check it against Linus's tree to make sure it applies , just
> to let you known.
> Nick


-- 
~Randy
