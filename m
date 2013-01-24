Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3AXDBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:01:46 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:64241 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3AXDBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:01:38 -0500
MIME-Version: 1.0
In-Reply-To: <51009F6D.5040001@samsung.com>
References: <1358954692-5625-1-git-send-email-tobetter@gmail.com>
	<51009F6D.5040001@samsung.com>
Date: Thu, 24 Jan 2013 12:01:36 +0900
Message-ID: <CADoNuNeEv4B0F0iseSYHy+koC8jAGb_zyOZjOw_C6ObneOjOiQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Add MSHC compatible for Exynos4412
From: Dongjin Kim <tobetter@gmail.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: "unlisted-recipients: ,Chris Ball" <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaehoon,

Yes, completely agree with you but I wanted to keep "exynos5250_"
before Exynos4210's drv_data is sorted out. Anyway "exynos5_" would be
ok, I think.

Regards,
Dongjin.

On Thu, Jan 24, 2013 at 11:41 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> On 01/24/2013 12:24 AM, Dongjin Kim wrote:
>> This patch adds the compatible string for MSHC controller of Exynos4412, and
>> reuse the controller specific properties with Exynos5250 since those have same
>> features.
>>
>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> ---
>>  drivers/mmc/host/dw_mmc-exynos.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>> index 0cb9bcb..4f7685f 100644
>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>> @@ -204,6 +204,8 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
>>  };
>>
>>  static const struct of_device_id dw_mci_exynos_match[] = {
>> +     { .compatible = "samsung,exynos4412-dw-mshc",
>> +                     .data = &exynos5250_drv_data, },
> If we can use the same drv_data, should be changed to more generic name, not "exynos5250_".
>
> Best Regards,
> Jaehoon Chung
>>       { .compatible = "samsung,exynos5250-dw-mshc",
>>                       .data = &exynos5250_drv_data, },
>>       {},
>>
>
