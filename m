Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbbAKXkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:40:31 -0500
Received: from mail15.tpgi.com.au ([203.12.160.61]:57117 "EHLO
	mail15.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbAKXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:40:30 -0500
X-Greylist: delayed 26328 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2015 18:40:29 EST
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Mon, 12 Jan 2015 10:40:05 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
Message-ID: <54B3097A.6020302@paradise.net.nz>
Date: Mon, 12 Jan 2015 10:38:34 +1100
From: Emrys Bayliss <emrys@paradise.net.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>, Joe Perches <joe@perches.com>
CC: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Checkpatch fix: else after break or
 return
References: <1420993174-24908-1-git-send-email-emrys@paradise.net.nz> <1420994540.3690.2.camel@perches.com> <54B2EB5C.50508@gmail.com>
In-Reply-To: <54B2EB5C.50508@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bungle please disregard it.

I will send it again with a 'ret' variable if that's okay (one that
has been properly proofed and compiles).

My apologies. Sorry for completely wasting your time by not
checking properly.

On 01/12/2015 08:30 AM, Malcolm Priestley wrote:
>
>
> On 11/01/15 16:42, Joe Perches wrote:
>> On Mon, 2015-01-12 at 03:19 +1100, Emrys Bayliss wrote:
>>> This patch fixes the following checkpatch.pl error:
>>> rxtx.c:588: WARNING: else is not generally useful after a break or return
>>>
>>> Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
>>> ---
>>>   drivers/staging/vt6656/rxtx.c | 6 +-----
>>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
>>> index ea5140a..cc34704 100644
>>> --- a/drivers/staging/vt6656/rxtx.c
>>> +++ b/drivers/staging/vt6656/rxtx.c
>>> @@ -553,8 +553,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>>>               cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
>>>
>>>           memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
>>> -
>>> -        return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
>>>       } else {
>>>           struct vnt_cts *buf = &head->cts_g;
>>>           /* Get SignalField,ServiceField,Length */
>>> @@ -571,11 +569,9 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>>>               cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
>>>
>>>           memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
>>> -
>>> -        return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
>>>       }
>>>
>>> -    return 0;
>>> +    return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
>>>   }
>>>
>>>   static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
>>
>> This is not the same code.
>> Does this even compile?
>>
>> For the second block, you've changed
>> return <foo>_g(...) to <foo>_g_fb(...).
>>
> Yes, this is wrong and will cause CTS to fail.
>
>

