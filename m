Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDASDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:03:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49825 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaDASDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:03:03 -0400
Message-ID: <533AFF51.2070806@gmail.com>
Date: Wed, 02 Apr 2014 02:02:57 +0800
From: Nicolas Porcel <nicolasporcel06@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>
CC: "D. G. Jansen" <d.g.jansen@gmail.com>,
        Stefan Biereigel <stefan@biereigel.de>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Stefan Biereigel <security@biereigel-wb.de>,
        Lan Tianyu <lantianyu1986@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        San Zamoyski <san@plusnet.pl>, "D. Jansen" <dennis.jansen@web.de>,
        "Maurizio D'Addona" <mauritiusdadd@gmail.com>
Subject: Re: [REGRESSION 3.14-rc6] Samsung N150 lid does not "open" after
 suspend to RAM.
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com> <533014B1.4030307@biereigel-wb.de> <CAOLK0pyOV50Vqt+bX_QpH_tjL=8eWwvu+O70EvTOZ+ixWZmr3Q@mail.gmail.com> <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com> <5331E5EB.5000304@biereigel-wb.de> <5331E9E4.4050201@gmail.com> <5332099B.8090305@gmail.com> <5332AF10.90109@biereigel.de> <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com> <CAM6oVw2v9ptr0c08uPiB_3z3e41VO+Vp3OhoHXiBxagAOfPBZA@mail.gmail.com> <CAGf84QLcXnmjRQFsb7z09xMrKXG0DiO7gT_10QZqGMN0CJYnLA@mail.gmail.com> <533AA4A4.1010101@gmail.com> <CAGf84QJyzDTjd3=XJBDANJgwh4mT5yxPLoCrsMRuq5ZA8XJkJg@mail.gmail.com> <533AAEA3.6070703@gmail.com>
In-Reply-To: <533AAEA3.6070703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I managed to recompile the kernel. Here is what I see in the logs:
kernel: ACPI : EC: acpi_ec_clear: EC_SC 0x20
kernel: ACPI : EC: acpi_ec_clear: EC_SC 0x08
kernel: ACPI : EC: 1 stale EC events cleared

I hope this will help

Regards,

Nicolas Porcel

Le 01/04/2014 20:18, Nicolas Porcel a écrit :
> Sure, I understand that you need to test it, that's why I am asking. I 
> don't want an untested patch to be included in the kernel either. We 
> also have to make sure that the patch fix the regression for all the 
> affected Samsung laptops.
>
> For the EC_SC code, I am using the first version of the patch without 
> the pr_info line, so I need to recompile the kernel. I'll let you know 
> as soon as it's done.
>
> Best regards,
>
> Nicolas Porcel
>
> On 01/04/2014 19:58, Kieran Clancy wrote:
>> On Tue, Apr 1, 2014 at 10:06 PM, Nicolas Porcel
>> <nicolasporcel06@gmail.com> wrote:
>>> Do you have any idea of how much time will it take to merge it to the
>>> mainline ?
>> Apologies for the breakage. The key here is that we want a patch which
>> works 100% on all Samsung systems. If we rush a fix for this
>> regression, we may risk breaking things on other systems.
>>
>> Fortunately, the work-around in the case of this regression is very
>> simple (just repeat whatever event was ignored the first time, be it
>> lid open, ac plug, etc) compared to the bug which the original patch
>> fixed (which had no real workaround and caused near-permanent
>> malfunction).
>>
>> This is why I am asking people with Samsung systems to test the patch
>> (with the debug output I added in the kernel bugzilla attachment) and
>> confirm that it is working. I am also asking them to report EC_SC data
>> because we may be able to create a more targeted patch with this
>> information.
>>
>> Speaking of which, can you please let me know the EC_SC bytes you see
>> when you test it on your system, and if it is always the same?
>>
>> Once I hear back from users on a range of Samsung systems, I will
>> submit a patch. It should have enough time to land before 3.15. I will
>> also ask for it to be included in other stable branches.
>>
>> Kind regards,
>> Kieran
>

