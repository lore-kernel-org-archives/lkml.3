Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaFPPSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:18:44 -0400
Received: from linode.aoot.com ([69.164.194.13]:32867 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbaFPPSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:18:43 -0400
Message-ID: <539F0ACF.6080609@opengridcomputing.com>
Date: Mon, 16 Jun 2014 10:18:39 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>, Levente Kurusa <levex@linux.com>
CC: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3]Checks for Null value in function *get_skub
References: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>	<539F096F.8020502@linux.com> <CAPDOMVg8hthn2beTjHx94RRJeRHGGP1wyT0Y2KfscUtZGFfiCA@mail.gmail.com>
In-Reply-To: <CAPDOMVg8hthn2beTjHx94RRJeRHGGP1wyT0Y2KfscUtZGFfiCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/16/2014 10:14 AM, Nick Krause wrote:
> >From what I know yes so I would close the bug at the the link in
> my previous email and just void my patch.
> Cheers Nick

We shouldn't be kfree-ing an skb anyway.  Should use kfree_skb().

There is still a leak if skb is non-null and the skb is non linear or 
cloned.


> On Mon, Jun 16, 2014 at 11:12 AM, Levente Kurusa <levex@linux.com> wrote:
>> On 06/16/2014 05:08 PM, Nicholas Krause wrote:
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>    drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>>>    1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c
>>> b/drivers/infiniband/hw/cxgb4/cm.c
>>> index f9477e2..2d56983 100644
>>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>>> @@ -340,15 +340,13 @@ static int status2errno(int status)
>>>     */
>>>    static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>>>    {
>>>    if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>>>                   skb_trim(skb, 0);
>>>                   skb_get(skb);
>>>                   skb_reset_transport_header(skb);
>>>          } else {
>>> +               if (skb)
>>> +                       kfree (skb);
>>>                  skb = alloc_skb(len, gfp);
>>>          }
>>>          t4_set_arp_err_handler(skb, NULL, NULL);
>>>
>> Isn't kfree(NULL) legal?
>>
>> (i.e. the if statement is useless)
>>
>> Thanks,
>>      Levente Kurusa

