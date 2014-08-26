Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbaHZIEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:04:45 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46885 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933859AbaHZIEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:04:36 -0400
Message-ID: <53FC3F89.9030406@st.com>
Date: Tue, 26 Aug 2014 10:04:25 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
Cc: <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@altera.com>
Subject: Re: [PATCH] net: stmmac: fix warning from Sparse for socfpga
References: <1409037076-14775-1-git-send-email-lftan@altera.com>	<53FC363E.6050604@st.com> <CAFiDJ5_LspyDPnXnimZ=TRiZD191XQRvwqgfZSOU-ziu_DUx=Q@mail.gmail.com>
In-Reply-To: <CAFiDJ5_LspyDPnXnimZ=TRiZD191XQRvwqgfZSOU-ziu_DUx=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.46]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_03:2014-08-25,2014-08-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2014 9:47 AM, Ley Foon Tan wrote:
> On Tue, Aug 26, 2014 at 3:24 PM, Giuseppe CAVALLARO
> <peppe.cavallaro@st.com> wrote:
>>> @@ -119,7 +119,8 @@ static int socfpga_dwmac_parse_data(struct
>>> socfpga_dwmac *dwmac, struct device *
>>>                          return -EINVAL;
>>>                  }
>>>
>>> -               dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
>>> +               dwmac->splitter_base =
>>> +                       (void __iomem *)devm_ioremap_resource(dev,
>>
>>
>> I think, no casting should be done:
>>
>>     dwmac->splitter_base = devm_ioremap_resource(dev, ....
> Oh ya, since both are same type. Will send new patch.

thx a lot

>
>>
>> patch should be for net-next
> Do you mean the patch need based on net-next git?

yes I do.

> I'm using linux-next git now.

ok, can you signal it in the subject (e.g.  [PATCH (net-next)]
This can help on reviewing and IIRC required by Maintainer too

>
> Thanks.

welcome

BR
peppe

> Regards
> Ley Foon
>
>

