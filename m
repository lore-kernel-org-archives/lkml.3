Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbbAKVaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:30:12 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:51915 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAKVaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:30:10 -0500
Message-ID: <54B2EB5C.50508@gmail.com>
Date: Sun, 11 Jan 2015 21:30:04 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Emrys Bayliss <emrys@paradise.net.nz>
CC: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Checkpatch fix: else after break or
 return
References: <1420993174-24908-1-git-send-email-emrys@paradise.net.nz> <1420994540.3690.2.camel@perches.com>
In-Reply-To: <1420994540.3690.2.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/01/15 16:42, Joe Perches wrote:
> On Mon, 2015-01-12 at 03:19 +1100, Emrys Bayliss wrote:
>> This patch fixes the following checkpatch.pl error:
>> rxtx.c:588: WARNING: else is not generally useful after a break or return
>>
>> Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
>> ---
>>   drivers/staging/vt6656/rxtx.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
>> index ea5140a..cc34704 100644
>> --- a/drivers/staging/vt6656/rxtx.c
>> +++ b/drivers/staging/vt6656/rxtx.c
>> @@ -553,8 +553,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>>   			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
>>
>>   		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
>> -
>> -		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
>>   	} else {
>>   		struct vnt_cts *buf = &head->cts_g;
>>   		/* Get SignalField,ServiceField,Length */
>> @@ -571,11 +569,9 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>>   			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
>>
>>   		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
>> -
>> -		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
>>   	}
>>
>> -	return 0;
>> +	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
>>   }
>>
>>   static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
>
> This is not the same code.
> Does this even compile?
>
> For the second block, you've changed
> return <foo>_g(...) to <foo>_g_fb(...).
>
Yes, this is wrong and will cause CTS to fail.

