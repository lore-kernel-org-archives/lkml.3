Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3AVMBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:01:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57353 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab3AVMBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:01:14 -0500
Message-ID: <50FE7F80.4060202@ti.com>
Date: Tue, 22 Jan 2013 17:31:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH] ARM: davinci: da850 evm: pass platform data for adv7343
 encoder
References: <1358237081-2584-1-git-send-email-prabhakar.lad@ti.com> <CA+V-a8t26rMT+Prz-p5627AYiv2Nndr57mxE4E6F9UJ3CkRzng@mail.gmail.com>
In-Reply-To: <CA+V-a8t26rMT+Prz-p5627AYiv2Nndr57mxE4E6F9UJ3CkRzng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2013 5:27 PM, Prabhakar Lad wrote:
> Sekhar,
> 
> On Tue, Jan 15, 2013 at 1:34 PM, Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
>> Without this patch the adv7343 encoder was being set to default
>> configuration which caused display not to work on this board.
>> This patch passes the necessary platform data required for adv7343
>> encoder to work on da850 evm.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> ---
>>  This patch is dependent on http://patchwork.linuxtv.org/patch/16272/
>>
> Since this patch depends on media [1] , I would like to get this patch
> through media tree as fix for 3.8. Could you review and ACK it ?

The patch looks good to me. Feel free to add my

Acked-by: Sekhar Nori <nsekhar@ti.com>

and merge through the media tree to ease the dependencies.

Thanks,
Sekhar

> 
> [1] http://patchwork.linuxtv.org/patch/16391/
> 
> Regards,
> --Prabhakar
> 
>>  arch/arm/mach-davinci/board-da850-evm.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
>> index 0299915..d0e3ec3 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -1256,11 +1256,24 @@ static struct vpif_capture_config da850_vpif_capture_config = {
>>  };
>>
>>  /* VPIF display configuration */
>> +
>> +static struct adv7343_platform_data adv7343_pdata = {
>> +       .mode_config = {
>> +               .dac_3 = 1,
>> +               .dac_2 = 1,
>> +               .dac_1 = 1,
>> +       },
>> +       .sd_config = {
>> +               .sd_dac_out1 = 1,
>> +       },
>> +};
>> +
>>  static struct vpif_subdev_info da850_vpif_subdev[] = {
>>         {
>>                 .name = "adv7343",
>>                 .board_info = {
>>                         I2C_BOARD_INFO("adv7343", 0x2a),
>> +                       .platform_data = &adv7343_pdata,
>>                 },
>>         },
>>  };
>> --
>> 1.7.4.1
>>
> 
> 
