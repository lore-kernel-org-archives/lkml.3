Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaKJVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:09:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaKJVJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:09:55 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Chris Ruffin <cmruffin@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8723au: change typecast to match type returned by htons()
References: <1415650025-16403-1-git-send-email-cmruffin@gmail.com>
	<wrfjlhnivmb9.fsf@redhat.com> <54611FF5.40405@broadcom.com>
Date: Mon, 10 Nov 2014 16:09:37 -0500
In-Reply-To: <54611FF5.40405@broadcom.com> (Arend van Spriel's message of
	"Mon, 10 Nov 2014 21:28:37 +0100")
Message-ID: <wrfj8ujivk32.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend van Spriel <arend@broadcom.com> writes:
> On 10-11-14 21:21, Jes Sorensen wrote:
>> Chris Ruffin <cmruffin@gmail.com> writes:
>>> Using a u16 pointer typecast for a result from htons() results in
>>> the following warning from sparse:
>>>
>>> drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36: warning:
>>> incorrect type in assignment (different base types)
>>> drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36: expected
>>> unsigned short [unsigned] [short] [usertype] <noident>
>>> drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36: got restricted
>>> __be16 [usertype] <noident>
>>>
>>> This patch fixes the issue by using an endian-specific typecast
>>> that will always match the type returned by htons().
>>>
>>> Signed-off-by: Chris Ruffin <cmruffin@gmail.com>
>>> ---
>>>  drivers/staging/rtl8723au/core/rtw_xmit.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> Looks fine to me
>> 
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>>>
>>> diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c
>>> b/drivers/staging/rtl8723au/core/rtw_xmit.c
>>> index a0f7e27..44ef55c 100644
>>> --- a/drivers/staging/rtl8723au/core/rtw_xmit.c
>>> +++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
>>> @@ -1276,7 +1276,7 @@ s32 rtw_put_snap23a(u8 *data, u16 h_proto)
>>>  	snap->oui[0] = oui[0];
>>>  	snap->oui[1] = oui[1];
>>>  	snap->oui[2] = oui[2];
>>> -	*(u16 *)(data + SNAP_SIZE) = htons(h_proto);
>>> +	*(__be16 *)(data + SNAP_SIZE) = htons(h_proto);
>
> Could (data + SNAP_SIZE) be on a unaligned address?

It shouldn't but probably better to take it into account. I am moving
things around in this code right now, so I'll just fix it in a follow-on
patch to this one.

Cheers,
Jes
