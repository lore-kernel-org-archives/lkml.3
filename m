Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbaGAQZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:25:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57075 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201AbaGAQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:25:19 -0400
X-Sasl-enc: F74WJIlg110heSYkuv96tKkkFVps1XiKCRTRm2zkVbgB 1404231911
Message-ID: <53B2E0E3.1080007@fastmail.fm>
Date: Tue, 01 Jul 2014 17:25:07 +0100
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ben Chan <benchan@chromium.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: move T_CAPABILITY bit definitions to
 hci.h
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm> <1404219616-1788-3-git-send-email-mpappas@fastmail.fm> <CAC5Y2nNhQvDve4SiV7Eat9t_82S3S26sU+p4R=vGQ2hk4tdAMg@mail.gmail.com>
In-Reply-To: <CAC5Y2nNhQvDve4SiV7Eat9t_82S3S26sU+p4R=vGQ2hk4tdAMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 04:37 PM, Ben Chan wrote:
> On Tue, Jul 1, 2014 at 6:00 AM, Michalis Pappas <mpappas@fastmail.fm> wrote:
>> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
>> ---
>>  drivers/staging/gdm72xx/gdm_wimax.c | 10 +++-------
>>  drivers/staging/gdm72xx/hci.h       |  6 ++++++
>>  2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
>> index 63a760b..1fc64a9 100644
>> --- a/drivers/staging/gdm72xx/gdm_wimax.c
>> +++ b/drivers/staging/gdm72xx/gdm_wimax.c
>> @@ -600,10 +600,6 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>>         u16 len = 0;
>>         u32 val = 0;
>>
>> -       #define BIT_MULTI_CS    0
>> -       #define BIT_WIMAX               1
>> -       #define BIT_QOS                 2
>> -       #define BIT_AGGREGATION 3
>>
>>         /* GetInformation mac address */
>>         len = 0;
>> @@ -612,12 +608,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>>         hci->length = H2B(len);
>>         gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
>>
>> -       val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
>> +       val = (1 << T_CAPABILITY_BIT_WIMAX) | (1 << T_CAPABILITY_BIT_MULTI_CS);
>>         #if defined(CONFIG_WIMAX_GDM72XX_QOS)
>> -       val |= (1<<BIT_QOS);
>> +       val |= (1 << T_CAPABILITY_BIT_QOS);
>>         #endif
>>         #if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
>> -       val |= (1<<BIT_AGGREGATION);
>> +       val |= (1 << T_CAPABILITY_BIT_AGGREGATION);
>>         #endif
> 
> [Ben] We can simply the code by defining these constants as bitmasks
> instead, e.g.
> 
> T_CAPABILITY_MULTI_CS  (1 << 0)
> T_CAPABILITY_WIMAX  (1 << 1)
> T_CAPABILITY_QOS  (1 << 2)
> T_CAPABILITY_AGGREGATION  (1 << 3)
> 

Agreed, I'll submit a new patch.

