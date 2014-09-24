Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIXIih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:38:37 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47486 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbaIXIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:38:33 -0400
Message-ID: <542282E3.8080102@st.com>
Date: Wed, 24 Sep 2014 10:37:55 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Peter Griffin <peter.griffin@linaro.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <kernel@stlinux.com>, <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [STLinux Kernel] [PATCH 1/3] media: st-rc: move to using reset_control_get_optional
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>	<1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org>	<20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd> <54227CD2.5020705@linaro.org>
In-Reply-To: <54227CD2.5020705@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_04:2014-09-23,2014-09-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini, Peter,

On 09/24/2014 10:12 AM, Srinivas Kandagatla wrote:
> Hi Pete,
> 
> On 23/09/14 19:02, Peter Griffin wrote:
>> Hi Srini,
>>
>> On Mon, 22 Sep 2014, Srinivas Kandagatla wrote:
>>
>>> This patch fixes a compilation error while building with the
>>> random kernel configuration.
>>>
>>> drivers/media/rc/st_rc.c: In function 'st_rc_probe':
>>> drivers/media/rc/st_rc.c:281:2: error: implicit declaration of
>>> function 'reset_control_get' [-Werror=implicit-function-declaration]
>>>    rc_dev->rstc = reset_control_get(dev, NULL);
>>>
>>> drivers/media/rc/st_rc.c:281:15: warning: assignment makes pointer
>>> from integer without a cast [enabled by default]
>>>    rc_dev->rstc = reset_control_get(dev, NULL);
>>
>> Is managing the reset line actually optional though? I can't test atm 
>> as I don't have
>> access to my board, but quite often if the IP's aren't taken out of 
>> reset reads / writes
>> to the perhpiheral will hang the SoC.
>>
> Yes and No.
> AFAIK reset line is optional on SOCs like 7108, 7141.
> I think having the driver function without reset might is a value add in 
> case we plan to reuse the mainline driver for these SOCs.
> 
> On latest ARM SOCs with SBC the IRB IP is moved to SBC and held in reset.
> Am not sure, if the reset line is optional in next generation SOCs?

I don't know for next SoCs, but I think it makes sense to make it optional.

Regards,
Maxime

> 
>> If managing the reset line isn't optional then I think the correct fix 
>> is to add
>> depends on RESET_CONTROLLER in the kconfig.
> I agree.
> This would make the COMPILE_TEST less useful though.
> 
> 
> thanks,
> srini
>>
>> This will then do the right thing for randconfig builds as well.
>>
>> regards,
>>
>> Peter.
>>
> 
> _______________________________________________
> Kernel mailing list
> Kernel@stlinux.com
> http://www.stlinux.com/mailman/listinfo/kernel
