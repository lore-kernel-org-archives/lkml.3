Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaLCRSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:18:03 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:37528 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCRSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:18:01 -0500
MIME-Version: 1.0
In-Reply-To: <s5htx1d6x49.wl-tiwai@suse.de>
References: <1417561975-27627-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <s5htx1d6x49.wl-tiwai@suse.de>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Wed, 3 Dec 2014 18:17:39 +0100
Message-ID: <CAFo99gZ_+AH2h0fxNfcy3Rm9ciiRe5HFs2zhqdN3GXhZUymYig@mail.gmail.com>
Subject: Re: [PATCH] sound: pci: cmipci.c: Cleaning up function that are not
 used anywhere
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Benoit Taine <benoit.taine@lip6.fr>,
        Bjorn Helgaas <bhelgaas@google.com>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-03 7:55 GMT+01:00 Takashi Iwai <tiwai@suse.de>:
> At Wed,  3 Dec 2014 00:12:55 +0100,
> Rickard Strandqvist wrote:
>>
>> Remove function snd_cmipci_pll_rmn() that is not used anywhere.
>
> It's an experimental code that is currently disabled.  Keeping such a
> code would be still meaningful if anyone wants to start a similar
> experiment again.
>
>
> Takashi
>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  sound/pci/cmipci.c |   41 -----------------------------------------
>>  1 file changed, 41 deletions(-)
>>
>> diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
>> index 85ed403..e33edae 100644
>> --- a/sound/pci/cmipci.c
>> +++ b/sound/pci/cmipci.c
>> @@ -615,47 +615,6 @@ static unsigned int snd_cmipci_rate_freq(unsigned int rate)
>>
>>  #ifdef USE_VAR48KRATE
>>  /*
>> - * Determine PLL values for frequency setup, maybe the CMI8338 (CMI8738???)
>> - * does it this way .. maybe not.  Never get any information from C-Media about
>> - * that <werner@suse.de>.
>> - */
>> -static int snd_cmipci_pll_rmn(unsigned int rate, unsigned int adcmult, int *r, int *m, int *n)
>> -{
>> -     unsigned int delta, tolerance;
>> -     int xm, xn, xr;
>> -
>> -     for (*r = 0; rate < CM_MAXIMUM_RATE/adcmult; *r += (1<<5))
>> -             rate <<= 1;
>> -     *n = -1;
>> -     if (*r > 0xff)
>> -             goto out;
>> -     tolerance = rate*CM_TOLERANCE_RATE;
>> -
>> -     for (xn = (1+2); xn < (0x1f+2); xn++) {
>> -             for (xm = (1+2); xm < (0xff+2); xm++) {
>> -                     xr = ((CM_REFFREQ_XIN/adcmult) * xm) / xn;
>> -
>> -                     if (xr < rate)
>> -                             delta = rate - xr;
>> -                     else
>> -                             delta = xr - rate;
>> -
>> -                     /*
>> -                      * If we found one, remember this,
>> -                      * and try to find a closer one
>> -                      */
>> -                     if (delta < tolerance) {
>> -                             tolerance = delta;
>> -                             *m = xm - 2;
>> -                             *n = xn - 2;
>> -                     }
>> -             }
>> -     }
>> -out:
>> -     return (*n > -1);
>> -}
>> -
>> -/*
>>   * Program pll register bits, I assume that the 8 registers 0xf8 up to 0xff
>>   * are mapped onto the 8 ADC/DAC sampling frequency which can be chosen
>>   * at the register CM_REG_FUNCTRL1 (0x04).
>> --
>> 1.7.10.4


Hi

Maybe it had been appropriate to add some comment or something then....?

And thanks Bjorn, was a better idea to write like in the patch text.

Kind regards
Rickard Strandqvist
