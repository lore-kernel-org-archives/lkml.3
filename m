Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3JKBJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:09:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44358 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab3JKBJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:09:06 -0400
Message-ID: <52574F89.6010308@marvell.com>
Date: Fri, 11 Oct 2013 09:08:25 +0800
From: Qiao Zhou <zhouqiao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: zhangfei gao <zhangfei.gao@gmail.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Subject: Re: [PATCH] dma: mmp_tdma: add multiple burst size support for 910-squ
References: <1381297228-2443-1-git-send-email-zhouqiao@marvell.com> <1381297228-2443-2-git-send-email-zhouqiao@marvell.com> <CAMj5BkgVw+uSCKzvY5tJY68NHUo_Ty-nvyhDQ+PGQo-kL7suWA@mail.gmail.com>
In-Reply-To: <CAMj5BkgVw+uSCKzvY5tJY68NHUo_Ty-nvyhDQ+PGQo-kL7suWA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-10_06:2013-10-10,2013-10-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310100126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 09:54 PM, zhangfei gao wrote:
> On Wed, Oct 9, 2013 at 1:40 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
>> add multiple burst size support for 910-squ.
>>
>> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
>> ---
>>   drivers/dma/mmp_tdma.c |   25 ++++++++++++++++++++++++-
>>   1 files changed, 24 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
>> index 38cb517..d84354b 100644
>> --- a/drivers/dma/mmp_tdma.c
>> +++ b/drivers/dma/mmp_tdma.c
>> @@ -228,8 +228,31 @@ static int mmp_tdma_config_chan(struct mmp_tdma_chan *tdmac)
>>                          return -EINVAL;
>>                  }
>>          } else if (tdmac->type == PXA910_SQU) {
>> -               tdcr |= TDCR_BURSTSZ_SQU_32B;
>>                  tdcr |= TDCR_SSPMOD;
>> +
>> +               switch (tdmac->burst_sz) {
>> +               case 1:
>> +                       tdcr |= TDCR_BURSTSZ_SQU_1B;
>> +                       break;
>> +               case 2:
>> +                       tdcr |= TDCR_BURSTSZ_SQU_2B;
>> +                       break;
>> +               case 4:
>> +                       tdcr |= TDCR_BURSTSZ_SQU_4B;
>> +                       break;
>> +               case 8:
>> +                       tdcr |= TDCR_BURSTSZ_SQU_8B;
>> +                       break;
>> +               case 16:
>> +                       tdcr |= TDCR_BURSTSZ_SQU_16B;
>> +                       break;
>> +               case 32:
>> +                       tdcr |= TDCR_BURSTSZ_SQU_32B;
>> +                       break;
>> +               default:
>> +                       dev_err(tdmac->dev, "mmp_tdma: unknown burst size.\n");
>> +                       return -EINVAL;
>> +               }
>
> Sorry, do I make mistake,
> Not find definition TDCR_BURSTSZ_SQU_16B ~
> Only find
> #define TDCR_BURSTSZ_SQU_32B    (0x7 << 6)
uploaded the wrong version. sorry. I have already submitted the v2 
patch. thanks.
>
> Thanks
>


-- 

Best Regards
Qiao
