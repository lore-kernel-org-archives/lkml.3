Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaDXPL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:11:28 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36778 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbaDXPL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140424144533.GH26661@saruman.home>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
	<1398342897-23670-4-git-send-email-cw00.choi@samsung.com>
	<20140424144533.GH26661@saruman.home>
Date: Fri, 25 Apr 2014 00:11:26 +0900
Message-ID: <CAGTfZH1CO3VmfHSgqc5bVBxeHBX5j8CYZ+uQ6zU0d_MPv5AKJw@mail.gmail.com>
Subject: Re: [PATCHv3 3/9] extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        gg@slimlogic.co.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        ckeepax@opensource.wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 24, 2014 at 09:34:51PM +0900, Chanwoo Choi wrote:
>> This patch use devm_extcon_dev_allocate() to simplify the memory control
>> of extcon device.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>  drivers/extcon/extcon-max8997.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
>> index 804a446..e2ee2f5 100644
>> --- a/drivers/extcon/extcon-max8997.c
>> +++ b/drivers/extcon/extcon-max8997.c
>> @@ -699,8 +699,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>>       }
>>
>>       /* External connector */
>> -     info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
>> -                               GFP_KERNEL);
>> +     info->edev = devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cable);
>>       if (!info->edev) {
>
> and here you never check for IS_ERR(info->evdev)
>
> NAK
>
> I suspect all following patches have the same defect.

OK, I'll use IS_ERR() instead of checking NULL.

Thanks,
Chanwoo Choi
