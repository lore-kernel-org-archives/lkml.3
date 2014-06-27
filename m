Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaF0LuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:50:16 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:55646 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaF0LuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140605111328.GA11244@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
	<1401892320-18211-12-git-send-email-gabriel.fernandez@linaro.org>
	<20140605111328.GA11244@griffinp-ThinkPad-X1-Carbon-2nd>
Date: Fri, 27 Jun 2014 13:50:11 +0200
Message-ID: <CAG374jBM8_iVw3V4x4KdTgVH6t39ZR9ksjiG5aPAyC0QzLuO8Q@mail.gmail.com>
Subject: Re: [STLinux Kernel] [PATCH RESEND 11/12] drivers: clk: st: Update
 frequency tables for fs660c32 and fs432c65
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 13:13, Peter Griffin <peter.griffin@linaro.org> wrote:
> Hi Gabi,
>
> See my comment below
>
> On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:
>
>> This patch extend the range of possible frequencies of the fs432c65
>> and fs660c32 Quad frequency synthesizers.
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  drivers/clk/st/clkgen-fsyn.c | 65 ++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 57 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
>> index d7a0341..97a422f 100644
>> --- a/drivers/clk/st/clkgen-fsyn.c
>> +++ b/drivers/clk/st/clkgen-fsyn.c
>> @@ -50,17 +50,66 @@ static struct stm_fs fs216c65_rtbl[] = {
>>  };
>>
>>  static struct stm_fs fs432c65_rtbl[] = {
>> -     { .mdiv = 0x1f, .pe = 0x0,      .sdiv = 0x7,    .nsdiv = 0 },   /* 625   Khz */
>> -     { .mdiv = 0x11, .pe = 0x1c72,   .sdiv = 0x2,    .nsdiv = 1 },   /* 108   MHz */
>> -     { .mdiv = 0x19, .pe = 0x121a,   .sdiv = 0x0,    .nsdiv = 1 },   /* 297   MHz */
>> +     { .mdiv = 0x1f, .pe = 0x0,      .sdiv = 0x7,    .nsdiv = 0 },   /* 625     Khz */
>> +     { .mdiv = 0x13, .pe = 0x777c,   .sdiv = 0x4,    .nsdiv = 1 },   /* 25.175  MHz */
>> +     { .mdiv = 0x19, .pe = 0x4d35,   .sdiv = 0x2,    .nsdiv = 0 },   /* 25.200  MHz */
>> +     { .mdiv = 0x11, .pe = 0x1c72,   .sdiv = 0x4,    .nsdiv = 1 },   /* 27.000  MHz */
>> +     { .mdiv = 0x17, .pe = 0x28f5,   .sdiv = 0x2,    .nsdiv = 0 },   /* 27.027  MHz */
>> +     { .mdiv = 0x16, .pe = 0x3359,   .sdiv = 0x2,    .nsdiv = 0 },   /* 28.320  MHz */
>> +     { .mdiv = 0x1f, .pe = 0x2083,   .sdiv = 0x3,    .nsdiv = 1 },   /* 30.240  MHz */
>> +     { .mdiv = 0x1e, .pe = 0x430d,   .sdiv = 0x3,    .nsdiv = 1 },   /* 31.500  MHz */
>> +     { .mdiv = 0x17, .pe = 0x0,      .sdiv = 0x3,    .nsdiv = 1 },   /* 40.000  MHz */
>> +     { .mdiv = 0x19, .pe = 0x121a,   .sdiv = 0x1,    .nsdiv = 0 },   /* 49.500  MHz */
>> +     { .mdiv = 0x13, .pe = 0x6667,   .sdiv = 0x3,    .nsdiv = 1 },   /* 50.000  MHz */
>> +     { .mdiv = 0x10, .pe = 0x1ee6,   .sdiv = 0x3,    .nsdiv = 1 },   /* 57.284  MHz */
>> +     { .mdiv = 0x1d, .pe = 0x3b14,   .sdiv = 0x2,    .nsdiv = 1 },   /* 65.000  MHz */
>> +     { .mdiv = 0x12, .pe = 0x7c65,   .sdiv = 0x1,    .nsdiv = 0 },   /* 71.000  MHz */
>> +     { .mdiv = 0x19, .pe = 0xecd,    .sdiv = 0x2,    .nsdiv = 1 },   /* 74.176  MHz */
>> +     { .mdiv = 0x19, .pe = 0x121a,   .sdiv = 0x2,    .nsdiv = 1 },   /* 74.250  MHz */
>> +     { .mdiv = 0x19, .pe = 0x3334,   .sdiv = 0x2,    .nsdiv = 1 },   /* 75.000  MHz */
>> +     { .mdiv = 0x18, .pe = 0x5138,   .sdiv = 0x2,    .nsdiv = 1 },   /* 78.800  MHz */
>> +     { .mdiv = 0x1d, .pe = 0x77d,    .sdiv = 0x0,    .nsdiv = 0 },   /* 85.500  MHz */
>> +     { .mdiv = 0x1c, .pe = 0x13d5,   .sdiv = 0x0,    .nsdiv = 0 },   /* 88.750  MHz */
>> +     { .mdiv = 0x11, .pe = 0x1c72,   .sdiv = 0x2,    .nsdiv = 1 },   /* 108.000 MHz */
>> +     { .mdiv = 0x17, .pe = 0x28f5,   .sdiv = 0x0,    .nsdiv = 0 },   /* 108.108 MHz */
>> +     { .mdiv = 0x10, .pe = 0x6e26,   .sdiv = 0x2,    .nsdiv = 1 },   /* 118.963 MHz */
>> +     { .mdiv = 0x15, .pe = 0x3e63,   .sdiv = 0x0,    .nsdiv = 0 },   /* 119.000 MHz */
>> +     { .mdiv = 0x1c, .pe = 0x471d,   .sdiv = 0x1,    .nsdiv = 1 },   /* 135.000 MHz */
>> +     { .mdiv = 0x19, .pe = 0xecd,    .sdiv = 0x1,    .nsdiv = 1 },   /* 148.352 MHz */
>> +     { .mdiv = 0x19, .pe = 0x121a,   .sdiv = 0x1,    .nsdiv = 1 },   /* 148.500 MHz */
>> +     { .mdiv = 0x19, .pe = 0x121a,   .sdiv = 0x0,    .nsdiv = 1 },   /* 297     MHz */
>>  };
>>
>>  static struct stm_fs fs660c32_rtbl[] = {
>> -     { .mdiv = 0x01, .pe = 0x2aaa,   .sdiv = 0x8,    .nsdiv = 0 },   /* 600   KHz */
>> -     { .mdiv = 0x02, .pe = 0x3d33,   .sdiv = 0x0,    .nsdiv = 0 },   /* 148.5 Mhz */
>> -     { .mdiv = 0x13, .pe = 0x5bcc,   .sdiv = 0x0,    .nsdiv = 1 },   /* 297   Mhz */
>> -     { .mdiv = 0x0e, .pe = 0x1025,   .sdiv = 0x0,    .nsdiv = 1 },   /* 333   Mhz */
>> -     { .mdiv = 0x0b, .pe = 0x715f,   .sdiv = 0x0,    .nsdiv = 1 },   /* 350   Mhz */
>> +     { .mdiv = 0x14, .pe = 0x376b,   .sdiv = 0x4,    .nsdiv = 1 },   /* 25.175  MHz */
>> +     { .mdiv = 0x14, .pe = 0x30c3,   .sdiv = 0x4,    .nsdiv = 1 },   /* 25.200  MHz */
>> +     { .mdiv = 0x10, .pe = 0x71c7,   .sdiv = 0x4,    .nsdiv = 1 },   /* 27.000  MHz */
>> +     { .mdiv = 0x00, .pe = 0x47af,   .sdiv = 0x3,    .nsdiv = 0 },   /* 27.027  MHz */
>> +     { .mdiv = 0x0e, .pe = 0x4e1a,   .sdiv = 0x4,    .nsdiv = 1 },   /* 28.320  MHz */
>> +     { .mdiv = 0x0b, .pe = 0x534d,   .sdiv = 0x4,    .nsdiv = 1 },   /* 30.240  MHz */
>> +     { .mdiv = 0x17, .pe = 0x6fbf,   .sdiv = 0x2,    .nsdiv = 0 },   /* 31.500  MHz */
>> +     { .mdiv = 0x01, .pe = 0x0,      .sdiv = 0x4,    .nsdiv = 1 },   /* 40.000  MHz */
>> +     { .mdiv = 0x15, .pe = 0x2aab,   .sdiv = 0x3,    .nsdiv = 1 },   /* 49.500  MHz */
>> +     { .mdiv = 0x14, .pe = 0x6666,   .sdiv = 0x3,    .nsdiv = 1 },   /* 50.000  MHz */
>> +     { .mdiv = 0x1d, .pe = 0x395f,   .sdiv = 0x1,    .nsdiv = 0 },   /* 57.284  MHz */
>> +     { .mdiv = 0x08, .pe = 0x4ec5,   .sdiv = 0x3,    .nsdiv = 1 },   /* 65.000  MHz */
>> +     { .mdiv = 0x05, .pe = 0x1770,   .sdiv = 0x3,    .nsdiv = 1 },   /* 71.000  MHz */
>> +     { .mdiv = 0x03, .pe = 0x4ba7,   .sdiv = 0x3,    .nsdiv = 1 },   /* 74.176  MHz */
>> +     { .mdiv = 0x0f, .pe = 0x3426,   .sdiv = 0x1,    .nsdiv = 0 },   /* 74.250  MHz */
>> +     { .mdiv = 0x0e, .pe = 0x7777,   .sdiv = 0x1,    .nsdiv = 0 },   /* 75.000  MHz */
>> +     { .mdiv = 0x01, .pe = 0x4053,   .sdiv = 0x3,    .nsdiv = 1 },   /* 78.800  MHz */
>> +     { .mdiv = 0x09, .pe = 0x15b5,   .sdiv = 0x1,    .nsdiv = 0 },   /* 85.500  MHz */
>> +     { .mdiv = 0x1b, .pe = 0x3f19,   .sdiv = 0x2,    .nsdiv = 1 },   /* 88.750  MHz */
>> +     { .mdiv = 0x10, .pe = 0x71c7,   .sdiv = 0x2,    .nsdiv = 1 },   /* 108.000 MHz */
>> +     { .mdiv = 0x00, .pe = 0x47af,   .sdiv = 0x1,    .nsdiv = 0 },   /* 108.108 MHz */
>> +     { .mdiv = 0x0c, .pe = 0x3118,   .sdiv = 0x2,    .nsdiv = 1 },   /* 118.963 MHz */
>> +     { .mdiv = 0x0c, .pe = 0x2f54,   .sdiv = 0x2,    .nsdiv = 1 },   /* 119.000 MHz */
>> +     { .mdiv = 0x07, .pe = 0xe39,    .sdiv = 0x2,    .nsdiv = 1 },   /* 135.000 MHz */
>> +     { .mdiv = 0x03, .pe = 0x4ba7,   .sdiv = 0x2,    .nsdiv = 1 },   /* 148.352 MHz */
>> +     { .mdiv = 0x0f, .pe = 0x3426,   .sdiv = 0x0,    .nsdiv = 0 },   /* 148.500 MHz */
>> +     { .mdiv = 0x03, .pe = 0x4ba7,   .sdiv = 0x1,    .nsdiv = 1 },   /* 296.704 MHz */
>> +     { .mdiv = 0x03, .pe = 0x471c,   .sdiv = 0x1,    .nsdiv = 1 },   /* 297     MHz */
>> +     { .mdiv = 0x1c, .pe = 0x0,      .sdiv = 0x0,    .nsdiv = 1 },   /* 352     Mhz */
>>  };
>
> These lookup tables should be 'static const'
>

Done
Thanks Peter

> Once fixed:
>  Acked-by: Peter Griffin <peter.griffin@linaro.org>
>
> Regards,
>
> Peter.
