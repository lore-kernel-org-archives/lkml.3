Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaIXIN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:13:26 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47632 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaIXIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:12:06 -0400
Message-ID: <54227CD2.5020705@linaro.org>
Date: Wed, 24 Sep 2014 09:12:02 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 1/3] media: st-rc: move to using reset_control_get_optional
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org> <1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org> <20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On 23/09/14 19:02, Peter Griffin wrote:
> Hi Srini,
>
> On Mon, 22 Sep 2014, Srinivas Kandagatla wrote:
>
>> This patch fixes a compilation error while building with the
>> random kernel configuration.
>>
>> drivers/media/rc/st_rc.c: In function 'st_rc_probe':
>> drivers/media/rc/st_rc.c:281:2: error: implicit declaration of
>> function 'reset_control_get' [-Werror=implicit-function-declaration]
>>    rc_dev->rstc = reset_control_get(dev, NULL);
>>
>> drivers/media/rc/st_rc.c:281:15: warning: assignment makes pointer
>> from integer without a cast [enabled by default]
>>    rc_dev->rstc = reset_control_get(dev, NULL);
>
> Is managing the reset line actually optional though? I can't test atm as I don't have
> access to my board, but quite often if the IP's aren't taken out of reset reads / writes
> to the perhpiheral will hang the SoC.
>
Yes and No.
AFAIK reset line is optional on SOCs like 7108, 7141.
I think having the driver function without reset might is a value add in 
case we plan to reuse the mainline driver for these SOCs.

On latest ARM SOCs with SBC the IRB IP is moved to SBC and held in reset.
Am not sure, if the reset line is optional in next generation SOCs?

> If managing the reset line isn't optional then I think the correct fix is to add
> depends on RESET_CONTROLLER in the kconfig.
I agree.
This would make the COMPILE_TEST less useful though.


thanks,
srini
>
> This will then do the right thing for randconfig builds as well.
>
> regards,
>
> Peter.
>
