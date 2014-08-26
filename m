Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbaHZHrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:47:33 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:35247 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934013AbaHZHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <53FC363E.6050604@st.com>
References: <1409037076-14775-1-git-send-email-lftan@altera.com>
	<53FC363E.6050604@st.com>
Date: Tue, 26 Aug 2014 15:47:28 +0800
X-Google-Sender-Auth: UfgGE5Q12bLx0WuoUWClj_makvg
Message-ID: <CAFiDJ5_LspyDPnXnimZ=TRiZD191XQRvwqgfZSOU-ziu_DUx=Q@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: fix warning from Sparse for socfpga
From: Ley Foon Tan <lftan@altera.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 3:24 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
>> @@ -119,7 +119,8 @@ static int socfpga_dwmac_parse_data(struct
>> socfpga_dwmac *dwmac, struct device *
>>                         return -EINVAL;
>>                 }
>>
>> -               dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
>> +               dwmac->splitter_base =
>> +                       (void __iomem *)devm_ioremap_resource(dev,
>
>
> I think, no casting should be done:
>
>    dwmac->splitter_base = devm_ioremap_resource(dev, ....
Oh ya, since both are same type. Will send new patch.

>
> patch should be for net-next
Do you mean the patch need based on net-next git?
I'm using linux-next git now.

Thanks.

Regards
Ley Foon
