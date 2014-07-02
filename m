Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaGBLVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:21:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaGBLVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <s5hha3058j2.wl%tiwai@suse.de>
References: <1404270473-4285-1-git-send-email-mcgrof@do-not-panic.com>
	<s5hha3058j2.wl%tiwai@suse.de>
Date: Wed, 2 Jul 2014 19:21:07 +0800
Message-ID: <CACVXFVOSLVPFanNavDVoPLM9YBrxxNm_PCuZwBahVY74+1=niw@mail.gmail.com>
Subject: Re: [PATCH v2] firmware loader: inform direct failure when udev
 loader is disabled
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Tom Gundersen <teg@jklm.no>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 7:01 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue,  1 Jul 2014 20:07:53 -0700,
> Luis R. Rodriguez wrote:
>>
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> Now that the udev firmware loader is optional request_firmware()
>> will not provide any information on the kernel ring buffer if
>> direct firmware loading failed and udev firmware loading is disabled.
>> If no information is needed request_firmware_direct() should be used
>> for optional firmware, at which point drivers can take on the onus
>> over informing of any failures, if udev firmware loading is disabled
>> though we should at the very least provide some sort of information
>> as when the udev loader was enabled by default back in the days.
>>
>> With this change with a simple firmware load test module [0]:
>>
>> Example output without FW_LOADER_USER_HELPER_FALLBACK
>>
>> platform fake-dev.0: Direct firmware load for fake.bin failed
>> with error -2
>>
>> Example with FW_LOADER_USER_HELPER_FALLBACK
>>
>> platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
>> platform fake-dev.0: Falling back to user helper
>>
>> Without this change without FW_LOADER_USER_HELPER_FALLBACK we
>> get no output logged upon failure.
>>
>> Cc: Tom Gundersen <teg@jklm.no>
>> Cc: Ming Lei <ming.lei@canonical.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Abhay Salunke <Abhay_Salunke@dell.com>
>> Cc: Stefan Roese <sr@denx.de>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Kay Sievers <kay@vrfy.org>
>> Cc: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
>> ---
>>
>> This v2 modifies the error to always be called and only in the
>> request_firmware_direct case do we not send smoke signals.
>>
>>  drivers/base/firmware_class.c | 13 +++++++------
>>  include/linux/firmware.h      | 15 ++++++++-------
>>  2 files changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index 46ea5f4..60d0e53 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -109,6 +109,7 @@ static inline long firmware_loading_timeout(void)
>>  #else
>>  #define FW_OPT_FALLBACK              0
>>  #endif
>> +#define FW_OPT_DIRECT_ONLY (1U << 3)
>
> I'd name it like FW_OPT_NO_WARN or such.
> Other than that, looks good to me.

IMO, DIRECT_ONLY is better because it can be
extend to other usages in future.

Thanks,
--
Ming Lei
