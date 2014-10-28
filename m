Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaJ1IVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:21:48 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60377 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaJ1IVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <20141028053134.GH60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
	<1414005163-3461-8-git-send-email-fransklaver@gmail.com>
	<20141028053134.GH60814@vmdeb7>
Date: Tue, 28 Oct 2014 09:21:43 +0100
Message-ID: <CAH6sp9P3rm86vq=Js1N6BN83-mYgxJEqCu4edEsKWvtyyFPXPQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] eeepc-laptop: document fan_pwm conversions
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 6:31 AM, Darren Hart <dvhart@infradead.org> wrote:
> On Wed, Oct 22, 2014 at 09:12:42PM +0200, Frans Klaver wrote:
>> eeepc_get_fan_pwm and eeepc_set_fan_pwm convert the PWM value read from
>> the fan to a range lmsensors understands. Unfortunately this is only
>> clear if you are familiar with how lmsensors handles duty cycles.
>>
>> Introduce two conversion functions that document the goal of these
>> conversions.
>>
>> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c | 16 +++++++++++++---
>>  1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> index f820bb3..275a239 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -974,18 +974,28 @@ static struct platform_driver platform_driver = {
>>  #define EEEPC_EC_SFB0      0xD0
>>  #define EEEPC_EC_FAN_CTRL  (EEEPC_EC_SFB0 + 3) /* Byte containing SF25  */
>>
>> +static inline int eeepc_pwm_to_lmsensors(int value)
>> +{
>> +     return value * 255 / 100;
>> +}
>> +
>> +static inline int eeepc_lmsensors_to_pwm(int value)
>> +{
>> +     value = clamp_val(value, 0, 255);
>> +     return value * 100 / 255;
>
> Says the guy cleaning up all the magic numbers.... ;-)
>
> But yeah, this is fine IMO. Applied.

Heh, I don't think this is any more or less magic than

    #define CONVERT_TO_LMSENSORS (255 / 100)

    value = value * CONVERT_TO_LMSENSORS;

or

    #define lmify(v) v * 255 / 100

    value = lmify(v);

But since you've just applied it, I would say you have pretty much the
same opinion.

Thanks,
Frans
