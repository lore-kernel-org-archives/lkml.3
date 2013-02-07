Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3BGGmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:42:31 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63550 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BGGma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <5112FE21.4020404@ahsoftware.de>
References: <5112EA69.6010100@ahsoftware.de>
	<5112FE21.4020404@ahsoftware.de>
Date: Thu, 7 Feb 2013 07:42:29 +0100
X-Google-Sender-Auth: Bb8xywyCa2Su-yWq9hzdHeN_E_E
Message-ID: <CAMuHMdXu0-9=wHevviG=4s5fC=wxkT9XbXhP6ztOyGkkeb6+8Q@mail.gmail.com>
Subject: Re: MODSIGN without RTC?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 2:06 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 07.02.2013 00:42, schrieb Alexander Holler:
>> I wanted to try out MODSIGN with kernel 3.7.6 and I've just got hit by:
>>
>> [    1.346445] X.509: Cert 6a23533cec71c4c52a1618fb4d830e06aa90474e is
>> not yet valid
>>
>> The reason is likely that the (ARM) device in question doesn't have a
>> RTC (oh, that topic again ;) ) and gets it's time on boot through NTP.
>>
>> The used certificate was generated automatically. Having a look at it,
>> the following is shown:
>>
>>         Validity
>>              Not Before: Feb  6 02:56:46 2013 GMT
>>              Not After : Jan 13 02:56:46 2113 GMT
>>
>> Without having thought about possible security problems, my first idea
>> would be to let the validity start at 1970. As I never did such I never
>> had thought about possible implications when doing such (e.g. I don't
>> know if someone checks the start date for plausabilitiy)
>>
>> Another solution would be to retry loading of the certificate if the
>> time gets set (and e.g. differs more than a year).
>>
>> Has someone already thought about how to solve that problem? Or did
>> everyone use sane systems which have a (working) RTC?
>
>
> Another option would be to make a configure option to just ignore the date.

Or an option to auto-advance the clock to the "Not Before" date if needed...

> I'm not sure if I would like to use MODSIGN when I have to fear that the
> machine wouldn't start when the RTC fails or got set to a wrong date.

Hmm, nice failure mode...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
