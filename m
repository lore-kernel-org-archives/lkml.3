Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbbA2BnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:43:25 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64267 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130AbbA2BnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:43:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150128224317.GC591@fuloong-minipc.musicnaut.iki.fi>
References: <1422481087-30938-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150128224317.GC591@fuloong-minipc.musicnaut.iki.fi>
Date: Wed, 28 Jan 2015 23:56:41 +0100
Message-ID: <CAKXHbyNH-dpzJXeE+4vmmQLmkPBR249zy5PS93i05L=wruMeZg@mail.gmail.com>
Subject: Re: [PATCH] staging: xgifb: XGI_main_26: Change variables that is
 never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vitor Braga <vitorpybraga@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Thomas Gummerer <t.gummerer@gmail.com>,
        Brian Vandre <bvandre@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-28 23:43 GMT+01:00 Aaro Koskinen <aaro.koskinen@iki.fi>:
> Hi,
>
> On Wed, Jan 28, 2015 at 10:38:07PM +0100, Rickard Strandqvist wrote:
>> Variable ar assigned a value that is never used.
>> Instead use the struct variable of the same name.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/xgifb/XGI_main_26.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
>> index 709d49e..ecfdf34 100644
>> --- a/drivers/staging/xgifb/XGI_main_26.c
>> +++ b/drivers/staging/xgifb/XGI_main_26.c
>> @@ -1233,7 +1233,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
>>       unsigned int vtotal = 0;
>>       unsigned int drate = 0, hrate = 0;
>>       int found_mode = 0;
>> -     int refresh_rate, search_idx;
>> +     int search_idx;
>>
>>       if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
>>               vtotal = var->upper_margin + var->yres + var->lower_margin
>> @@ -1271,7 +1271,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
>>
>>       /* Calculation wrong for 1024x600 - force it to 60Hz */
>>       if ((var->xres == 1024) && (var->yres == 600))
>> -             refresh_rate = 60;
>> +             xgifb_info->refresh_rate = 60;
>
> You are changing behaviour here. Did you test it, is it fixing something?
> Otherwise you could just delete the whole if block...
>
> A.


Hi

Yes, thats why there is another commit message.

But no, but when I check the code so it looked very much like a code miss.
And that you wanted to put refresh_rate = 60, which looks to be a default value.

Kind regards
Rickard Strandqvist
