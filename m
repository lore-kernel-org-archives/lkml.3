Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaHCEbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 00:31:33 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61584 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaHCEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 00:31:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140803035931.GA24059@mguzik.redhat.com>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
	<20140803035931.GA24059@mguzik.redhat.com>
Date: Sun, 3 Aug 2014 00:31:30 -0400
Message-ID: <CAPDOMVh16no_Lh=4cPEpXJheCU67DJJS6EBtg9AH_0yUXxXSPg@mail.gmail.com>
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef statement
 in sg_set_bf
From: Nick Krause <xerofoify@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2014 at 11:59 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
> On Sat, Aug 02, 2014 at 10:56:13PM -0400, Nicholas Krause wrote:
>> This changes the ifdef statement in sg_set_bg to !CONFIG_DEBUG_SG in order
>> to avoid a bug with xhci dequence/enquence functions.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  include/linux/scatterlist.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>> index adae88f..62de7b3 100644
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -111,7 +111,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
>>  static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>>                             unsigned int buflen)
>>  {
>> -#ifdef CONFIG_DEBUG_SG
>> +#ifdef !CONFIG_DEBUG_SG
>>       BUG_ON(!virt_addr_valid(buf));
>>  #endif
>
> Have you tried compiling this? IIRC you said you would compile your
> stuff, what hapened to that?
>
> What exactly were you trying to achieve? Did this BUG_ON detect a
> problem on your system and now you are trying to silence it?
>
> The change would be wrong even if it compiled since it would just
> execute the assertion only when debug is disabled.
>
> --
> Mateusz Guzik
This is the mailing theme I am getting this from,[xhci] kernel BUG at
include/linux/scatterlist.h:115.
I hope this answers your question about the BUG_ON and yes I did
compile check it with make
M=include/. I also checked usb and usb net directories too.
Regards,
 Nick
