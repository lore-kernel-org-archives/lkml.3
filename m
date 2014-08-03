Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaHCRav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 13:30:51 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53971 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaHCRaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 13:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <53DE2AEF.6080904@cogentembedded.com>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
	<53DE2AEF.6080904@cogentembedded.com>
Date: Sun, 3 Aug 2014 13:30:44 -0400
Message-ID: <CAPDOMVgTNSTzXENWZvWhuJvHRoPBRBYSExNxrwqeFGyQ44YA-w@mail.gmail.com>
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef statement
 in sg_set_bf
From: Nick Krause <xerofoify@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 8:28 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 03-08-2014 6:56, Nicholas Krause wrote:
>
>> This changes the ifdef statement  in sg_set_bg to !CONFIG_DEBUG_SG in
>> order
>> to avoid a bug with xhci dequence/enquence functions.
>
>
>    dequeue/enqueue?
>
>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>   include/linux/scatterlist.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>
>> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>> index adae88f..62de7b3 100644
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist
>> *sg)
>>   static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>>                               unsigned int buflen)
>>   {
>> -#ifdef CONFIG_DEBUG_SG
>> +#ifdef !CONFIG_DEBUG_SG
>
>
>    Didn't you mean #ifndef instead? I guess you didn't even try to
> build-test this.
>
>
>>         BUG_ON(!virt_addr_valid(buf));
>>   #endif
>>         sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
>
>
> WBR, Sergei
>
I am going to stay around and learn more but am going to check my
patches better as this is
my fault.
Regards Nick
