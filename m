Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaETHzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:55:20 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:41625 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbaETHzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:55:17 -0400
Message-ID: <537B0A15.409@st.com>
Date: Tue, 20 May 2014 09:53:57 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Subject: Re: [PATCH v4 6/6] ARM: dts: STiH407: Add B2120 board support
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com> <1394614210-15698-7-git-send-email-maxime.coquelin@st.com> <CAOesGMg5Jk_XB3zdfKz8VxRObYbFO8OMuRyo7Ba-kavANbci1w@mail.gmail.com> <20140520072048.GC20874@lee--X1> <CAOesGMioLwX3jgGEsR=rHV0u6yR54b4x8BfyZ91vjJnMapUHew@mail.gmail.com> <20140520074353.GD20874@lee--X1>
In-Reply-To: <20140520074353.GD20874@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-19_03:2014-05-19,2014-05-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/20/2014 09:43 AM, Lee Jones wrote:
>>>>> +       soc {
>>>>> +               sbc_serial0: serial@9530000 {
>>>>> +                       status = "okay";
>>>>> +               };
>>>>
>>>> You might want to consider reference-based syntax here instead, so you
>>>> don't have to mimic the hierarchy. That'd be (at the root level of the
>>>> file, below this secion:
>>>>
>>>> &sbc_serial0: {
>>>>          status = "okay";
>>>> };
>>>
>>> I'm personally not keen on this scheme.  It's sometimes helpful to know
>>> the hierarchy and I don't think it's a large overhead to format the
>>> subordinate DTS files in this way.
>>>
>>> Please consider not enforcing this.
>>
>> Definitely not enforcing it, and I didn't use to like it either but it
>> has some real upsides.
>>
>> In particular, it saves a lot of grief when you're changing something
>> like the unit-id of a node in .dtsi and forget to do the same update
>> in the dts.
>
> I'm not entirely sure what a unit-id is, but I can see that there
> would be benefits to using the referenced-based syntax as you call
> it.  If any of those benefits hold true here I won't push back, but I
> would personally like to see us default to the hierarchical scheme.


+1, I would prefer to keep the hierarchical scheme.
