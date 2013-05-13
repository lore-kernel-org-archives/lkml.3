Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3EMIxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:53:37 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:7767 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab3EMIxd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:53:33 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z5105h2005kzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: Libo Chen <libo.chen@huawei.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>
Subject: RE: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral before
 it init successful
Thread-Topic: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral before
 it init successful
Thread-Index: AQHOTI9QZNJIiFu0Q0GUTG2PZMAtGZj8hiKwgAFXpACABPX00A==
Date: Mon, 13 May 2013 08:52:11 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EEB7D7@NWD2MBX7.ad.analog.com>
References: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
 <1368088044-20408-2-git-send-email-libo.chen@huawei.com>
 <B168F8A49F4BCF4C84FD23DA5F6363EEAD57@NWD2MBX7.ad.analog.com>
 <518C46F0.6060507@huawei.com>
In-Reply-To: <518C46F0.6060507@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.72.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libo,

>-----Original Message-----
>From: Libo Chen [mailto:clbchenlibo.chen@huawei.com]
>Sent: Friday, May 10, 2013 9:02 AM
>To: Zhang, Sonic
>Cc: Libo Chen; wsa@the-dreams.de; uclinux-dist-devel@blackfin.uclinux.org;
>linux-kernel@vger.kernel.org; linux-i2c@vger.kernel.org; lizefan@huawei.com
>Subject: Re: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral before it init
>successful
>
>On 2013/5/9 16:33, Zhang, Sonic wrote:
>> Hi Libo,
>>
>>> -----Original Message-----
>>> From: Libo Chen [mailto:libo.chen@huawei.com]
>>> Sent: Thursday, May 09, 2013 4:27 PM
>>> To: Zhang, Sonic; wsa@the-dreams.de
>>> Cc: uclinux-dist-devel@blackfin.uclinux.org;
>>> linux-kernel@vger.kernel.org; linux- i2c@vger.kernel.org;
>>> lizefan@huawei.com; Libo Chen
>>> Subject: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral
>>> before it init successful
>>>
>>> down out_error_no_irq. When platform_get_irq fail, no need to free
>>> peripheral
>>>
>>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>>> ---
>>> drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c
>>> b/drivers/i2c/busses/i2c-bfin-twi.c
>>> index 05080c4..6617645 100644
>>> --- a/drivers/i2c/busses/i2c-bfin-twi.c
>>> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
>>> @@ -709,9 +709,9 @@ static int i2c_bfin_twi_probe(struct
>>> platform_device *pdev)
>>> out_error_add_adapter:
>>>       free_irq(iface->irq, iface);
>>> out_error_req_irq:
>>> -out_error_no_irq:
>>>       peripheral_free_list((unsigned short
>>> *)pdev->dev.platform_data);
>>> out_error_pin_mux:
>>> +out_error_no_irq:
>>>       iounmap(iface->regs_base);
>>> out_error_ioremap:
>>> out_error_get_res:
>>> --
>>
>> Sorry, but you didn't exchange as I suggested.
>> Should be
>>
>
>Hi Sonic,
>
>Look at peripheral_request_list()
>{
>       u16 cnt;
>       int ret;
>
>       for (cnt = 0; per[cnt] != 0; cnt++) {
>
>               ret = peripheral_request(per[cnt], label);
>
>               if (ret < 0) {
>                       for ( ; cnt > 0; cnt--)
>                               peripheral_free(per[cnt - 1]);
>
>                       return ret;
>               }
>       }
>
>       return 0;
>}
>
>
>When peripheral_request fail, it had called peripheral_free().
>So there is no reason to call peripheral_free_list again.
>
>Did I miss something else?
>
>
Yes, you are right. They are freed in peripheral_request_list() if any one fails.

You have my ACK on this patch.

Regards,

Sonic


