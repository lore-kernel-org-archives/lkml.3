Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaFPPOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:14:48 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:54070 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaFPPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <539F096F.8020502@linux.com>
References: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
	<539F096F.8020502@linux.com>
Date: Mon, 16 Jun 2014 11:14:45 -0400
Message-ID: <CAPDOMVg8hthn2beTjHx94RRJeRHGGP1wyT0Y2KfscUtZGFfiCA@mail.gmail.com>
Subject: Re: [PATCHv3]Checks for Null value in function *get_skub
From: Nick Krause <xerofoify@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what I know yes so I would close the bug at the the link in
my previous email and just void my patch.
Cheers Nick

On Mon, Jun 16, 2014 at 11:12 AM, Levente Kurusa <levex@linux.com> wrote:
> On 06/16/2014 05:08 PM, Nicholas Krause wrote:
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>   drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c
>> b/drivers/infiniband/hw/cxgb4/cm.c
>> index f9477e2..2d56983 100644
>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>> @@ -340,15 +340,13 @@ static int status2errno(int status)
>>    */
>>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>>   {
>>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>>                  skb_trim(skb, 0);
>>                  skb_get(skb);
>>                  skb_reset_transport_header(skb);
>>         } else {
>> +               if (skb)
>> +                       kfree (skb);
>>                 skb = alloc_skb(len, gfp);
>>         }
>>         t4_set_arp_err_handler(skb, NULL, NULL);
>>
>
> Isn't kfree(NULL) legal?
>
> (i.e. the if statement is useless)
>
> Thanks,
>     Levente Kurusa
