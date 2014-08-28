Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124AbaH1Ddt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:33:49 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59029 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaH1Ddq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140827.163343.715764078341662382.davem@davemloft.net>
References: <1409037076-14775-1-git-send-email-lftan@altera.com>
	<20140827.163343.715764078341662382.davem@davemloft.net>
Date: Thu, 28 Aug 2014 11:33:44 +0800
X-Google-Sender-Auth: 6pBVEt4bPhHQtT5IQ5o9t5OMUaE
Message-ID: <CAFiDJ5_AT5QoYiiWCMt5iWBbJkSzF8XAyMEX=H4boQSM4RDsbw@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: fix warning from Sparse for socfpga
From: Ley Foon Tan <lftan@altera.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vince Bridgers <vbridger@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 7:33 AM, David Miller <davem@davemloft.net> wrote:
> From: Ley Foon Tan <lftan@altera.com>
> Date: Tue, 26 Aug 2014 15:11:16 +0800
>
>> @@ -119,7 +119,8 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
>>                       return -EINVAL;
>>               }
>>
>> -             dwmac->splitter_base = (void *)devm_ioremap_resource(dev,
>> +             dwmac->splitter_base =
>> +                     (void __iomem *)devm_ioremap_resource(dev,
>>                       &res_splitter);
>
> Please either put this entire call on one line (it'll only be slightly
> over 80 columns, which is fine), or indent it properly.
>
> And by properly I meant that the second and subsequent lines of a function
> call must be indented precisely to the first column after the openning
> parenthesis of the function call on the first line.  You must use the
> appropriate number of TAB and SPACE characters necessary to do so.
>
> If it is indented using only TAB characters, it is very likely that you
> are doing it wrong.
Okay, will send in new patch to fix this.
Thanks.
