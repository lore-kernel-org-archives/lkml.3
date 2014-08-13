Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaHMNxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:53:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56305 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMNxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:53:00 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-fa-53eb6dba39e9
Message-id: <53EB6DBA.1080801@samsung.com>
Date: Wed, 13 Aug 2014 22:52:58 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sunil joshi <joshi@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mmc: dw_mmc: Make sure we don't get stuck when we get
 an error
References: <1400623670-2657-1-git-send-email-dianders@chromium.org>
 <001601cf74d4$3547a410$9fd6ec30$%jun@samsung.com>
 <CAD=FV=XCSTzX04M1TDCf9p4QqZrNsStTKG5s7uYbJNaAKmtkuw@mail.gmail.com>
In-reply-to: <CAD=FV=XCSTzX04M1TDCf9p4QqZrNsStTKG5s7uYbJNaAKmtkuw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkUHdX7utggx0rdS0mXN7OaLH99UY2
	i7PLDrJZvDryg8nixq82Vovvu76wW/QuuMpmcXnXHDaLI//7GS1mnN/HZPHkzExGi/UzXrNY
	fLh/kdni+Npwi4dHu1kd+D1mN1xk8dg56y67x6Eraxk97lzbw+Zx49VCJo++LasYPT5vkgtg
	j+KySUnNySxLLdK3S+DK6D//mL2ggbfi5IWXbA2Mc7m6GDk5JARMJFpn3WeFsMUkLtxbz9bF
	yMUhJLCUUeLa29ksMEWbtz5mgUgsYpTY+WwrO4TzmlHiSE8vM0gVr4CWRMfvtWAdLAKqEr9O
	NTOB2GwCOhLbvx0Hs0UFwiQOtc1jgqgXlPgx+R5YvYhAucScrT1MIEOZBf4zS2zs+s4IkhAW
	iJD4tesgG4gtJLCfUeJHewGIzSkQLLFj1iuwGmYBdYlJ8xYxQ9jyEpvXvGUGGSQhMJVD4tuv
	g4wQFwlIfJt8CGgbB1BCVmLTAWaI1yQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT
	0ouM9IoTc4tL89L1kvNzNzECo/v0v2d9OxhvHrA+xJgMtHIis5Rocj4wOeSVxBsamxlZmJqY
	GhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsb8KeXtgq6Tw/hrj7/l
	r5miEKMueET7n1rnt+MvnbizVa6WdyYsWPqiZemSuXdi96deroyWuDT3sOrzaOfCr3NPFCxz
	3526aMaV3ee9ZzqlTon7lTK7zVn67svs015SGjvehBpvXfAm8caXxcJrfnorf5LVOrXVRqbM
	6pSllGG01UzbZxvCBc8rsRRnJBpqMRcVJwIAlm72gAQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd1dua+DDWavVrGYcHk7o8X21xvZ
	LM4uO8hm8erIDyaLG7/aWC2+7/rCbtG74CqbxeVdc9gsjvzvZ7SYcX4fk8WTMzMZLdbPeM1i
	8eH+RWaL42vDLR4e7WZ14PeY3XCRxWPnrLvsHoeurGX0uHNtD5vHjVcLmTz6tqxi9Pi8SS6A
	PaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6HAl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0b/+cfsBQ28FScvvGRrYJzL
	1cXIySEhYCKxeetjFghbTOLCvfVsXYxcHEICixgldj7byg7hvGaUONLTywxSxSugJdHxey1Y
	B4uAqsSvU81MIDabgI7E9m/HwWxRgTCJQ23zmCDqBSV+TL4HVi8iUC4xZ2sPE8hQZoH/zBIb
	u74zgiSEBSIkfu06yAZiCwnsZ5T40V4AYnMKBEvsmPUKrIZZQF1i0rxFzBC2vMTmNW+ZJzAK
	zEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4dz6R3MK5qsDjEKMDB
	qMTD6xH1OliINbGsuDL3EKMEB7OSCO+PdKAQb0piZVVqUX58UWlOavEhRlNgEExklhJNzgem
	tbySeENjEzMjSyNzQwsjY3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYyzoy4cE/zOxf9d
	Y0WB+KKoZXuqghtr+3sL+3ZKJPiFvWZqbE71qKyUF9rtrSER0HLyn9jTCrlp4l+D316JsryZ
	Xugq5fzydvTZZeFSrE/DY8sMWUwq2PlvlDE9/b3fnPP5q55Ev81zXL58059fuUzI98+BoPaX
	laHbUiz29fyb93lPUt31CiWW4oxEQy3mouJEABolM+EzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 10:38 PM, Doug Anderson wrote:
> Hi,
> 
> On Wed, May 21, 2014 at 2:08 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> On Wed, May 21, 2014, Doug Anderson wrote:
>>> If we happened to get a data error at just the wrong time the dw_mmc
>>> driver could get into a state where it would never complete its
>>> request.  That would leave the caller just hanging there.
>>>
>>> We fix this two ways and both of the two fixes on their own appear to
>>> fix the problems we've seen:
>>>
>>> 1. Fix a race in the tasklet where the interrupt setting the data
>>>    error happens _just after_ we check for it, then we get a
>>>    EVENT_XFER_COMPLETE.  We fix this by repeating a bit of code.
>>> 2. Fix it so that if we detect that we've got an error in the "data
>>>    busy" state and we're not going to do anything else we end the
>>>    request and unblock anyone waiting.
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
>>
>> It will be applied after "mmc: dw_mmc: change to use recommended reset procedure"
>>
>> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
>>
>> Thanks,
>> Seungwon Jeon
> 
> I saw that Ulf applied "mmc: dw_mmc: change to use recommended reset
> procedure".  Could we apply this one now, too?  Do you want me to
> repost?
It's good that it will be merged with it.

Best Regards,
Jaehoon Chung

> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

