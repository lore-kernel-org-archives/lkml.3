Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbaDBLTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:19:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65075 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbaDBLTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140402110429.GJ18506@mwanda>
References: <20130826154908.GD12428@elgon.mountain>
	<20140402110429.GJ18506@mwanda>
Date: Wed, 2 Apr 2014 13:19:19 +0200
Message-ID: <CAKv+Gu9R7Y5OKy+P62FAyE2_zf7f=reiLQy-++XziXahbSM15A@mail.gmail.com>
Subject: Re: [patch] clk: vt8500: several forever loops
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Turquette <mturquette@linaro.org>, kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2014 13:04, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> This patch is still needed in linux-next.  It was Acked by Tony Prisk in
> a private email.
>
> Acked-by: Tony Prisk <linux@prisktech.co.nz>
>
> regards,
> dan carpenter
>
> On Mon, Aug 26, 2013 at 07:02:33PM +0300, Dan Carpenter wrote:
>> This does a bunch of looping like this:
>>
>>       for (div2 = 7; div2 >= 0; div2--)
>>
>> But unsigned values are always greater than or equal to zero so it just
>> loops and loops.  Really "mul", "div1" and "div2" should all be declared
>> as int for cleanliness sake.
>>

Apologies if this is a silly question from someone who is utterly
uninformed, but are values == 0 even legal for divisors?
It seems that, at least in some cases, 'div - 1' is or'ed into a
register value (WM8850_BITS_TO_VAL), and I don't think you are
expecting negative values there.
So perhaps instead, change the test to '> 0' ??

Regards,
Ard.





>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>> Static checker stuff.
>>
>> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
>> index 82306f5..8d5b57c 100644
>> --- a/drivers/clk/clk-vt8500.c
>> +++ b/drivers/clk/clk-vt8500.c
>> @@ -363,7 +363,7 @@ static void vt8500_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>>  static void wm8650_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>>                               u32 *multiplier, u32 *divisor1, u32 *divisor2)
>>  {
>> -     u32 mul, div1, div2;
>> +     int mul, div1, div2;
>>       u32 best_mul, best_div1, best_div2;
>>       unsigned long tclk, rate_err, best_err;
>>
>> @@ -431,7 +431,7 @@ static u32 wm8750_get_filter(u32 parent_rate, u32 divisor1)
>>  static void wm8750_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>>                               u32 *filter, u32 *multiplier, u32 *divisor1, u32 *divisor2)
>>  {
>> -     u32 mul, div1, div2;
>> +     int mul, div1, div2;
>>       u32 best_mul, best_div1, best_div2;
>>       unsigned long tclk, rate_err, best_err;
>>
>> @@ -475,7 +475,7 @@ static void wm8750_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>>  static void wm8850_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>>                               u32 *multiplier, u32 *divisor1, u32 *divisor2)
>>  {
>> -     u32 mul, div1, div2;
>> +     int mul, div1, div2;
>>       u32 best_mul, best_div1, best_div2;
>>       unsigned long tclk, rate_err, best_err;
>>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
