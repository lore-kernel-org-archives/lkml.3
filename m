Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaHaHYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 03:24:46 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57749 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHaHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 03:24:45 -0400
MIME-Version: 1.0
Date: Sun, 31 Aug 2014 10:24:44 +0300
Message-ID: <CA+Kvs9ms-G-vpVnZOrwy+hxuxHziUdogMMqXFOpcCTtSsYDcaw@mail.gmail.com>
Subject: Re: [PATCH] staging: netlogic: fixed checkpatch.pl styling warnings
From: Ramon Fried <ramon.fried@gmail.com>
To: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg
Thanks for your patience. this is the first time I doing it...
I created the patch against linux-next, I will do it again and send it.
Regarding CC's, this is the output of get_maintainer script, how do I
extract the relevant people out of its output ?
Warm regards,
Ramon.

On Sun, Aug 31, 2014 at 3:32 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Aug 31, 2014 at 03:16:48AM +0300, Ramon Fried wrote:
>> This patch fixes the following checkpatch.pl warnings:
>>
>> WARNING: Possible unnecessary 'out of memory' message
>> #146: FILE: ./xlr_net.c:146:
>> +       if (!skb) {
>> +               pr_err("SKB allocation failed\n");
>>
>> WARNING: Missing a blank line after declarations
>> #1107: FILE: ./xlr_net.c:1107:
>> +       struct xlr_net_priv *priv = platform_get_drvdata(pdev);
>> +       unregister_netdev(priv->ndev);
>>
>> Signed-off-by: Ramon Fried <ramon.fried@gmail.com>
>
> This is two different things, and as such, should be sent in 2 different
> patches?
>
> Also, you sent this to a lot of people, did they all really need it?
>
>> ---
>>  drivers/staging/netlogic/xlr_net.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
>> index 9bf407d..28a42831 100644
>> --- a/drivers/staging/netlogic/xlr_net.c
>> +++ b/drivers/staging/netlogic/xlr_net.c
>> @@ -142,10 +142,8 @@ static inline struct sk_buff *xlr_alloc_skb(void)
>>
>>       /* skb->data is cache aligned */
>>       skb = alloc_skb(XLR_RX_BUF_SIZE, GFP_ATOMIC);
>> -     if (!skb) {
>> -             pr_err("SKB allocation failed\n");
>> +     if (!skb)
>>               return NULL;
>> -     }
>>       mac_put_skb_back_ptr(skb);
>>       return skb;
>>  }
>> @@ -1104,6 +1102,7 @@ err_gmac:
>>  static int xlr_net_remove(struct platform_device *pdev)
>>  {
>>       struct xlr_net_priv *priv = platform_get_drvdata(pdev);
>> +
>>       unregister_netdev(priv->ndev);
>>       mdiobus_unregister(priv->mii_bus);
>>       mdiobus_free(priv->mii_bus);
>
> Finally, this patch doesn't apply at all to my tree, so even if I wanted
> to apply it, I couldn't.  Please refresh it against the staging-next
> branch of the staging.git tree on git.kernel.org, and if it is still
> relevant (hint, half of it isn't), then redo it and resend.
>
> thanks,
>
> greg k-h
