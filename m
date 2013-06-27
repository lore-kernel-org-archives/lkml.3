Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3F0DgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:36:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49007 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3F0DgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:36:14 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-bd-51cbb32d0eb6
Message-id: <51CBB332.2050903@samsung.com>
Date: Thu, 27 Jun 2013 12:36:18 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Bing Zhao'" <bzhao@marvell.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
 <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
 <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
 <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
 <CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
 <001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
 <477F20668A386D41ADCC57781B1F70430EA2AA2513@SC-VEXCH1.marvell.com>
 <CAD=FV=Xz-Cp86u=w8m91AEMJgH-o6cLkz6_udVw_3bm7Tm0OiA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430EA2AA251A@SC-VEXCH1.marvell.com>
 <CAD=FV=V6S7FsK+=+7EHDV74=Mw_iWecO2ZxVpVcd=p7ugW-sHA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430EA2BD5ECB@SC-VEXCH1.marvell.com>
 <001001ce720f$f96980c0$ec3c8240$%jun@samsung.com>
In-reply-to: <001001ce720f$f96980c0$ec3c8240$%jun@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkSFd38+lAg+ZLnBab18VbzNt6lNVi
	++uNbBZnlx1ks7jxq43V4vKuOWwWR/73M1qcuv6ZzWLD3amsFh/uX2S2WLjpEJsDt8fshoss
	Hjtn3WX3OHRlLaPHlRNNrB6TF15k9ujbsorR4/MmuQD2KC6blNSczLLUIn27BK6MqQ/uMRds
	46k4+nsaWwPjD84uRk4OCQETideLV7FD2GISF+6tZ+ti5OIQEljKKLHt2F8WmKI/vReYIRLT
	GSU6/r+Bcl4ySjRtfcAGUsUroCWxb/oCJhCbRUBV4vrq14wgNpuAjsT2b8fB4qICYRKbepqZ
	IOoFJX5Mvge0gYNDREBD4sv8BJCZzAJfmSTe758JNlNYIFri05ZD7BDLOtkl9q98wAyS4BSw
	k9g9dzszSDOzgJ7E/YtaIGFmAXmJzWveMkNc3cghceSULcQ9AhLfJh8C2yUhICux6QBUiaTE
	wRU3WCYwis1CctEshKGzkAxdwMi8ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwXk//e9a7
	g/H2AetDjMlAGycyS4km5wPjPa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC
	1KL4otKc1OJDjEwcnFINjAU8atF6v3j38oW8uLNWNOvuMSs3d8+duRPPKd3zChVnjhDI1hFc
	y3k1T+7uTYbyOLE9WkdZnPMYC9RTG3avtW8LFkievvlLl2/NsX0/vXK75/F3H3ln+5nx576t
	P5iZHs17eb9JjOlF4dnnG6e+UeldMGNvN9P/919ZBQLaz4nPibv5POHAOSWW4oxEQy3mouJE
	AApYTrDtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQV3dzacDDc7XWmxeF28xb+tRVovt
	rzeyWZxddpDN4savNlaLy7vmsFkc+d/PaHHq+mc2iw13p7JafLh/kdli4aZDbA7cHrMbLrJ4
	7Jx1l93j0JW1jB5XTjSxekxeeJHZo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmTH1wj7lgG0/F0d/T2BoYf3B2MXJySAiYSPzpvcAMYYtJXLi3nq2L
	kYtDSGA6o0TH/zfMEM5LRommrQ/YQKp4BbQk9k1fwARiswioSlxf/ZoRxGYT0JHY/u04WFxU
	IExiU08zE0S9oMSPyfdYuhg5OEQENCS+zE8Amcks8JVJ4v3+mWAzhQWiJT5tOcQOsayTXWL/
	ygdgJ3EK2EnsnrudGaSZWUBP4v5FLZAws4C8xOY1b5knMArMQrJiFkLVLCRVCxiZVzGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEJ4Nn0jsYVzVYHGIU4GBU4uH9wHg6UIg1say4MvcQowQH
	s5IIb2gOUIg3JbGyKrUoP76oNCe1+BBjMjAAJjJLiSbnAxNVXkm8obGJmZGlkbmhhZGxOWnC
	SuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwxipaRByVkucM3WG6fUftPE7tBXKcLjrHTIL/
	dX/vqjzkKNfvVGoYanpqbvWFeZb1dz403wkt6Bcr0qqapnykjv2B9pSbx/ZWq2xymFRbfzJw
	jeOqC392+p77mOz0qfeqRAXbuyVu06ItJQ/82JF0Om3JA7bvB/6dyjfRkZvUyDiJT9JCQvWG
	EktxRqKhFnNRcSIA+I71zEoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seungwon,

I didn't get the same result..In my case, it's working fine.
But as Bing's result, i will check more and share the result.

Best Regards,
Jaehoon Chung

On 06/26/2013 10:53 AM, Seungwon Jeon wrote:
> Hi Jaehoon,
> Do you have the same result?
> Could you share the result?
> 
> Thanks,
> Seungwon Jeon
> On Tuesday, June 25 2013, Bing Zhao wrote:
>>> I think the proposal on the table is to take Seungwon's patches
>>> instead of mine.  Assuming they solve your problems, I'm OK with that.
>>>  I think he was requesting testing the first of his two patches alone
>>> and then both of his two patches together.
>>
>> Test #1: Swungwon's patch #1 alone [1]
>> Test #2: Swungwon's patch #2 alone [1]
>> Test #3: Swungwon's patch #1 and #2 [1]
>> Test #4: Doug's original patch [2]
>>
>> Test #1 and #3: it doesn't work; system reboots due to kernel hung_task
>> Test #2 and #4: it works; instead of hung_task driver gets CRC error (which is expected)
>>
>> Thanks,
>> Bing
>>
>> [1] https://lkml.org/lkml/2013/4/8/316
>> [2] https://lkml.org/lkml/2013/3/15/583
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

