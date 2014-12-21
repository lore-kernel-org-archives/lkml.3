Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaLUQzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:55:54 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54865 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaLUQzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <201412211737.18917@pali>
References: <1419012268-20805-1-git-send-email-pali.rohar@gmail.com>
	<201412211309.41077@pali>
	<5496BBC4.90705@roeck-us.net>
	<201412211737.18917@pali>
Date: Sun, 21 Dec 2014 16:55:51 +0000
Message-ID: <CABz95_BYOzTxxhfZcUpkdvNriviNNjCgf_owB1yuRd7dS8h8jw@mail.gmail.com>
Subject: Re: [PATCH v3] i8k: Autodetect maximal fan speed and fan RPM multiplier
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 December 2014 at 16:37, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Sunday 21 December 2014 13:23:32 Guenter Roeck wrote:
>> On 12/21/2014 04:09 AM, Pali Rohár wrote:
>> > On Sunday 21 December 2014 12:57:08 Guenter Roeck wrote:
>> >>> -#define I8K_FAN_MULT             30
>> >>> +#define I8K_FAN_MAX_RPM          30000
>> >>>
>> >>>    #define I8K_MAX_TEMP           127
>> >>>
>> >>>    #define I8K_FN_NONE            0x00
>> >>>
>> >>> @@ -64,7 +66,7 @@ static DEFINE_MUTEX(i8k_mutex);
>> >>>
>> >>>    static char bios_version[4];
>> >>>    static struct device *i8k_hwmon_dev;
>> >>>    static u32 i8k_hwmon_flags;
>> >>>
>> >>> -static int i8k_fan_mult;
>> >>> +static int i8k_fan_mult = 30;
>> >>
>> >> Why did you drop I8K_FAN_MULT ?
>> >
>> > Because I think it is not needed anymore... It is used only
>> > in one place (there ^). But if you want I can revert it
>> > back.
>>
>> That is not a reason to drop a define.
>>
>> >>>    static int __init i8k_probe(void)
>> >>>    {
>> >>>
>> >>> + const struct i8k_config_data *conf;
>> >>
>> >> Why did you move this variable declaration ?
>> >
>> > Comes from previous version of patches where I moved all
>> > variables to start of function. I will revert this change.
>> >
>> >>> -         const struct i8k_config_data *conf = id->driver_data;
>> >>> +         conf = id->driver_data;
>> >>> +         if (fan_mult <= 0 && conf->fan_mult > 0)
>> >>
>> >> I still don't see the value in accepting fan_mult < 0
>> >> (compeared to == 0).
>> >
>> > Ok. What kernel driver should do if user load it with
>> > negative parameter? We should not propagate negative value
>> > to functions.
>>
>> You have multiple options: Ignore it (bad idea ;-), abort
>> loading the module with -EINVAL, or make the module parameter
>> an unsigned.
>>
>
> And how to make module parameter as unsigned? It is possible?
>
> Code
>
> module_param(fan_mult, unsigned int, 0);
>
> cause compile error:
>
> i8k.c:99:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘int’
> i8k.c:99:1: error: ‘param_ops_unsigned’ undeclared here (not in a function)


module_param(fan_mult, uint, 0);


Steven.
