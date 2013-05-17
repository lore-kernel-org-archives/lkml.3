Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3EQRu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:50:58 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:34233 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3EQRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:50:57 -0400
MIME-Version: 1.0
X-Originating-IP: [84.109.219.89]
In-Reply-To: <20130516221321.GG22822@zurbaran>
References: <1368615236-21345-1-git-send-email-leon@leon.nu> <20130516221321.GG22822@zurbaran>
From: Leon Romanovsky <leon@leon.nu>
Date: Fri, 17 May 2013 20:50:36 +0300
Message-ID: <CALq1K=J=Aeg11H5aX8bj-_EowdADJSg5oVY98c1q0v6YbhZEdg@mail.gmail.com>
Subject: Re: [PATCH] drivers: mfd: sec-code: Fix sizeof argument
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: sbkim73@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 1:13 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Leon,
>
> On Wed, May 15, 2013 at 01:53:56PM +0300, Leon Romanovsky wrote:
>> Signed-off-by: Leon Romanovsky <leon@leon.nu>
>> ---
>>  drivers/mfd/sec-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>> index 77ee26ef..5b740a3 100644
>> --- a/drivers/mfd/sec-core.c
>> +++ b/drivers/mfd/sec-core.c
>> @@ -121,7 +121,7 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
>>  {
>>       struct sec_platform_data *pd;
>>
>> -     pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
>> +     pd = devm_kzalloc(dev, sizeof(struct sec_platform_data), GFP_KERNEL);
> How is that fixing anything ?
Technically you are right, this fix brings code to be align to common
code convention and allows to automatic tools  correctly parse it.

>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/



--
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
