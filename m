Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaKJU33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:29:29 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17644 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaKJU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:29:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,354,1413270000"; 
   d="scan'208";a="50317340"
Message-ID: <54611FF5.40405@broadcom.com>
Date: Mon, 10 Nov 2014 21:28:37 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Chris Ruffin <cmruffin@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, Larry Finger <Larry.Finger@lwfinger.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8723au: change typecast to match type returned
 by htons()
References: <1415650025-16403-1-git-send-email-cmruffin@gmail.com> <wrfjlhnivmb9.fsf@redhat.com>
In-Reply-To: <wrfjlhnivmb9.fsf@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-14 21:21, Jes Sorensen wrote:
> Chris Ruffin <cmruffin@gmail.com> writes:
>> Using a u16 pointer typecast for a result from htons() results in the following warning from sparse:
>>
>> drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36: warning: incorrect type in assignment (different base types)
>> drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36:    expected unsigned short [unsigned] [short] [usertype] <noident>
>> drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36:    got restricted __be16 [usertype] <noident>
>>
>> This patch fixes the issue by using an endian-specific typecast
>> that will always match the type returned by htons().
>>
>> Signed-off-by: Chris Ruffin <cmruffin@gmail.com>
>> ---
>>  drivers/staging/rtl8723au/core/rtw_xmit.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Looks fine to me
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
>>
>> diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
>> index a0f7e27..44ef55c 100644
>> --- a/drivers/staging/rtl8723au/core/rtw_xmit.c
>> +++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
>> @@ -1276,7 +1276,7 @@ s32 rtw_put_snap23a(u8 *data, u16 h_proto)
>>  	snap->oui[0] = oui[0];
>>  	snap->oui[1] = oui[1];
>>  	snap->oui[2] = oui[2];
>> -	*(u16 *)(data + SNAP_SIZE) = htons(h_proto);
>> +	*(__be16 *)(data + SNAP_SIZE) = htons(h_proto);

Could (data + SNAP_SIZE) be on a unaligned address?

Regards,
Arend

>>  	return SNAP_SIZE + sizeof(u16);
>>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

