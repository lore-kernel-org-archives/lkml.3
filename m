Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3FKDvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 23:51:35 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56272 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3FKDve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 23:51:34 -0400
Message-ID: <51B69EBD.5000706@linaro.org>
Date: Tue, 11 Jun 2013 09:21:25 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 12/15] ASoC: spear: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-13-git-send-email-tushar.behera@linaro.org> <CAK9yfHygMQYpVRqrieyESJw9oZC5OzKoWWSUhYDYEd6KJigegA@mail.gmail.com>
In-Reply-To: <CAK9yfHygMQYpVRqrieyESJw9oZC5OzKoWWSUhYDYEd6KJigegA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:36 PM, Sachin Kamat wrote:
> On 10 June 2013 17:05, Tushar Behera <tushar.behera@linaro.org> wrote:
>> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
>> introduced devm_ioremap_resource() and deprecated the use of
>> devm_request_and_ioremap().
> 
> This patch does a little more than just conversion. May that change
> could be mentioned here.
> 

Sure. I will update that.

>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> CC: alsa-devel@alsa-project.org
>> CC: Liam Girdwood <lgirdwood@gmail.com>
>> CC: Mark Brown <broonie@kernel.org>
>> ---
>>  sound/soc/spear/spdif_out.c |   20 +++++---------------
>>  1 file changed, 5 insertions(+), 15 deletions(-)
>>
>> diff --git a/sound/soc/spear/spdif_out.c b/sound/soc/spear/spdif_out.c
>> index 4bde512..896ee7f 100644
>> --- a/sound/soc/spear/spdif_out.c
>> +++ b/sound/soc/spear/spdif_out.c
>> @@ -282,27 +282,17 @@ static int spdif_out_probe(struct platform_device *pdev)
>>         struct resource *res;
>>         int ret;
>>
>> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -       if (!res)
>> -               return -EINVAL;
>> -
>> -       if (!devm_request_mem_region(&pdev->dev, res->start,
>> -                               resource_size(res), pdev->name)) {
>> -               dev_warn(&pdev->dev, "Failed to get memory resourse\n");
>> -               return -ENOENT;
>> -       }
>> -
>>         host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
>>         if (!host) {
>>                 dev_warn(&pdev->dev, "kzalloc fail\n");
>>                 return -ENOMEM;
>>         }
>>
>> -       host->io_base = devm_request_and_ioremap(&pdev->dev, res->start,
>> -                               resource_size(res));
>> -       if (!host->io_base) {
>> -               dev_warn(&pdev->dev, "ioremap failed\n");
>> -               return -ENOMEM;
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       host->io_base = devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(host->io_base)) {
>> +               dev_warn(&pdev->dev, "devm_ioremap_resource failed\n");
> 
> This print is not needed as devm_ioremap_resource prints its own messages.
> 
> 

Ok.

Thanks.

-- 
Tushar Behera
