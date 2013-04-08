Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3DHFJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 01:09:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64705 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3DHFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 01:09:48 -0400
X-AuditID: cbfee68d-b7f786d000005188-8c-5162511b9f3f
Message-id: <51625128.7040405@samsung.com>
Date: Mon, 08 Apr 2013 14:10:00 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
In-reply-to: <515E88E3.5070507@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zHV3pwKRAg1mHOSw2r4u3mLf1KKvF
	9tcb2SzOLjvIZnHjVxurxeVdc9gsjvzvZ7Q4df0zm8WGu1NZLT7cv8hssXDTITYHbo/ZDRdZ
	PHbOusvucejKWkaPKyeaWD0mL7zI7NG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZL1Z+Yyl4
	zV4xceJj5gbGaWxdjJwcEgImEnuX32SCsMUkLtxbDxTn4hASWMYoMfXrFGaYoueTVkAlpjNK
	zG9ZAdYhJPCSUWLhAi4Qm1dAS+L0hatgcRYBVYmeE4fAbDYBHYnt346D2aICYRKbpvexQtQL
	SvyYfI8FxBYB6r1+ZCLYAmaBFmaJq8v3MYIkhAWiJT5tOcQOsfkco8TJRVPAEpwC2hL/r+0E
	m8oMtGF/K8Q/zALyEpvXvIU6+ye7xKIOb4iLBCS+TT4EtI0DKC4rsekAVImkxMEVN1gmMIrN
	QnLTLCRTZyGZuoCReRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGSMz27mC8fcD6EGMy0MqJ
	zFKiyfnAmM8riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA+Pc7xGdOZeS88XSGCfExLOoRgpvY3O7KloksvpH87k/xxn4Hy/YknjWsd2IbSqbiPIa
	Dx03r92fz6o6HHzCOenDifBbmrIbvfw/Xy0PftHHy2Zo/0HklP3ao8G/v39wkTR7G2depX+q
	jJXrZP/UlAL7i7u6W/z9P7Mter20IWC2Q+yZuObrNUosxRmJhlrMRcWJAFHZsFvvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQV3pwKRAg8NfmCw2r4u3mLf1KKvF
	9tcb2SzOLjvIZnHjVxurxeVdc9gsjvzvZ7Q4df0zm8WGu1NZLT7cv8hssXDTITYHbo/ZDRdZ
	PHbOusvucejKWkaPKyeaWD0mL7zI7NG3ZRWjx+dNcgHsUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCesYM16s/MZS8Jq9YuLEx8wNjNPYuhg5OSQETCSeT1oBZYtJXLi3Hsjm
	4hASmM4oMb9lBRNIQkjgJaPEwgVcIDavgJbE6QtXweIsAqoSPScOgdlsAjoS278dB7NFBcIk
	Nk3vY4WoF5T4MfkeC4gtAtR7/chEsAXMAi3MEleX72MESQgLREt82nKIHWLzOUaJk4umgCU4
	BbQl/l/bCTaVGWjD/laIs5kF5CU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnBKeCa1g3Flg8UhRgEORiUeXskfiYFCrIllxZW5hxglOJiVRHgDlZMC
	hXhTEiurUovy44tKc1KLDzEmA8NgIrOUaHI+MF3llcQbGpuYGVkamRmbmBsbkyasJM57oNU6
	UEggPbEkNTs1tSC1CGYLEwenVAOjk7v4LK/u2ZGiRbXJQo+Fzd6Zva2IWGmU2pxxuDzN6q5j
	0oV7bOYTMhef2zq5fueKrFD7KZkXblZuygn8fvLOf6bKtxGa2zLPXoxdeneDoKKN8eJQzyOM
	59NLv/qlK3PdbxFcV39DVv5cd8Wd0wx1bPsu2afV7Q1/5/Hm375Pa5TNirjsFt1UYinOSDTU
	Yi4qTgQAOHbgp00DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 04/05/2013 05:18 PM, Jaehoon Chung wrote:
> Hi Doug,
> 
> You're right..it's something wrong.
> Actually i didn't test with your patch, but your commit message is reasonable.
> 
> I will check until next week after test.
> 
> Best Regards,
> Jaehoon Chung
> 
> On 03/27/2013 03:06 AM, Doug Anderson wrote:
>> Jaehoon,
>>
>> On Mon, Mar 18, 2013 at 3:21 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi Doug,
>>>
>>> Great..i have found the problem like this.
>>> I will check your patch..and share the result.
>>
>> Did you have any time to check this patch?
>>
>> Thanks!
>>
>> -Doug
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

