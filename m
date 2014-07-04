Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbaGDNOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:14:48 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:63888 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaGDNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:14:47 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QEOcx1Ft+DpaWf0qqN8/jSv6KcucO/Jal+pWlFmof8RwlK56M1DtI=
X-RZG-CLASS-ID: mo05
Message-ID: <53B6A8C9.2030705@denx.de>
Date: Fri, 04 Jul 2014 15:14:49 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Lattice ECP3 FPGA: Correct endianness
References: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>	<1404403920.14741.44.camel@joe-AO725> <CAPwkgkOjr6y2M8FMytx6Ooz_LJwUtDckU1Q2piuV0mR0vOnD1w@mail.gmail.com>
In-Reply-To: <CAPwkgkOjr6y2M8FMytx6Ooz_LJwUtDckU1Q2piuV0mR0vOnD1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.07.2014 15:11, Jean-Michel Hautbois wrote:
> 2014-07-03 18:12 GMT+02:00 Joe Perches <joe@perches.com>:
>> trivial:
>>
>>> diff --git a/drivers/misc/lattice-ecp3-config.c
>> []
>>> @@ -165,8 +165,8 @@ static void firmware_load(const struct firmware
>>> *fw, void *context)
>>>
>>>       txbuf[0] = FPGA_CMD_READ_STATUS;
>>>       ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
>>> -    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
>>> -    status = *(u32 *)&rxbuf[4];
>>> +    dev_dbg(&spi->dev, "FPGA Status=%08x\n", be32_to_cpu(*(u32 *)&rxbuf[4]));
>>> +    status = be32_to_cpu(*(u32 *)&rxbuf[4]);
>>
>> This should emit a sparse error.
>> It'd be simpler as:
>>
>>          status = be32_to_cpu(*(__be32 *)&rxbuf[4]);
>>          dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);
>>
>>
>
> OK, do you want me to send a new patch including this modification ?

Yes. Please send a v2 patch version. You can add my "Acked-by:.." to the 
new version.

Thanks,
Stefan

