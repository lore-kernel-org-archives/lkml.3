Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaGHOPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:15:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65264 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaGHOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:15:34 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5d-53bbfd0388b3
Message-id: <53BBFCE3.4050806@samsung.com>
Date: Tue, 08 Jul 2014 16:14:59 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v5 4/5] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-5-git-send-email-pankaj.dubey@samsung.com>
 <53B198EB.80502@samsung.com> <001e01cf9820$18f29440$4ad7bcc0$@samsung.com>
In-reply-to: <001e01cf9820$18f29440$4ad7bcc0$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7rMf3cHG/w6p2qxbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpU0bGM0eLms+1MDtweLc09bB6b
	l9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bZbW+ZCw6yVVzadIu1gXEqaxcjJ4eEgInE
	gyktbBC2mMSFe+uBbC4OIYGljBLzD/9igXA+M0p8ObwOKMPBwSugJXFwux1IA4uAqsT6r7vB
	mtkE1CQ+NzwCs/mBStY0XWcBKRcViJB4fEEIJMwrICjxY/I9sJEiAtMYJS5eus0O4jALLGGU
	2DPjFCNIlbBAqMSGlW+hFl9hlPj8+BgTSIJTwEriw4FDzCA2s4COxP7WaWwQtrzE5jVvmScw
	Cs5CsmUWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJjC87GBcfszrEKMDB
	qMTDq1G7O1iINbGsuDL3EKMEB7OSCO+XU0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjLWh50tf
	XLOvYr92I5H9afO0hfkh1i98tt3RmdDYWR072TamvzQiteph+bZ/uSEfFqzJeDStw+XbeuND
	qZ2Jt998uHVU83Z/1Hnz5W85PZbtTrK4dNjC5Kj0sdpZTZGBa0T+3Xrr2jhBbbrdBu7M/3lx
	kX6Cs2QPtqpcOdLC16j6oVdYWm3LDSWW4oxEQy3mouJEAN3p7VRqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.07.2014 09:09, Pankaj Dubey wrote:
> On Monday, June 30, 2014 Tomasz Figa wrote:
>> On 25.06.2014 16:03, Pankaj Dubey wrote:
>>> +
>>> +	if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_init)
>>
>> In what conditions pmu_data will be NULL?
>>
> 
> What if we want driver to be probed but no data has been given?
> If driver gets probed it still can act as syscon provider, and other IPs can
> access
> PMU registers, but PMU functionality itself will not be available, for same
> reason
> I have put a check for pmu_data in powerdown_conf also.
> 

Is there any point in probing this driver just to register the syscon?
AFAIK if this driver errors out, the syscon platform driver will take
over and do what we want. That's why we have the second "syscon"
compatible string.

Best regards,
Tomasz
