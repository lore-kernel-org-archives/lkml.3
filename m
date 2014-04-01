Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaDALgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:36:15 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51777 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaDALgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:36:12 -0400
Message-ID: <533AA4A4.1010101@gmail.com>
Date: Tue, 01 Apr 2014 19:36:04 +0800
From: Nicolas Porcel <nicolasporcel06@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kieran Clancy <clancy.kieran@gmail.com>,
        "D. G. Jansen" <d.g.jansen@gmail.com>
CC: Stefan Biereigel <stefan@biereigel.de>,
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
References: <532FE3B2.9060808@biereigel-wb.de> <CAOLK0pxh4b3uzjD4jaPssD66K8g33uqahV1SzOAJAmQmnY4XqQ@mail.gmail.com> <533014B1.4030307@biereigel-wb.de> <CAOLK0pyOV50Vqt+bX_QpH_tjL=8eWwvu+O70EvTOZ+ixWZmr3Q@mail.gmail.com> <CAGf84Q+9RcQqi=YYvF8X8EJzbtk7dJYTxScaZN4347U+POQ4AQ@mail.gmail.com> <5331E5EB.5000304@biereigel-wb.de> <5331E9E4.4050201@gmail.com> <5332099B.8090305@gmail.com> <5332AF10.90109@biereigel.de> <CAGf84QJU+RKXV4AyQ7QBTKjpdPm3AYLtWTFio+-r3j8wyoEokA@mail.gmail.com> <CAM6oVw2v9ptr0c08uPiB_3z3e41VO+Vp3OhoHXiBxagAOfPBZA@mail.gmail.com> <CAGf84QLcXnmjRQFsb7z09xMrKXG0DiO7gT_10QZqGMN0CJYnLA@mail.gmail.com>
In-Reply-To: <CAGf84QLcXnmjRQFsb7z09xMrKXG0DiO7gT_10QZqGMN0CJYnLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for the patch. Since the update from 3.13.6 to 3.13.7, I have 
the same problem with the lid opening that is not detected on my Samsung 
N210. This patch fixes the problem.

I think this problem may affect more Samsung netbooks with similar 
hardware (N220, and maybe others).

Do you have any idea of how much time will it take to merge it to the 
mainline ?

Thank you

Regards

Nicolas Porcel

On 01/04/2014 17:53, Kieran Clancy wrote:
> On Sat, Mar 29, 2014 at 1:51 AM, D. G. Jansen <d.g.jansen@gmail.com> wrote:
>> This patch (processing events) works for me on Samsung 535.
> Hi Dennis and others,
>
> Thank you for testing. I have also been testing this patch for a
> couple of days, and have not encountered any problems.
>
> I have now submitted a request for testing on the kernel bugzilla
> entry for the bug fixed by the earlier patch in question:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=44161#c173
>
> The CC list has 62 users, so hopefully we will get some more testers.
> The comment I posted is repeated below:
>
> --------------
>
> Created attachment 131151 [details]
> process rather than discard events in acpi_ec_clear
>
> Hi all,
>
> If you have a machine that was (previously) affected by this bug,
> could you please take the time to try a new patch for this issue?
>
> A user with an older Samsung machine found that the earlier patch
> introduced some issues for them, so this is a new patch designed to be
> a better solution to the problem.
>
> Currently the new patch has only been tested on 2 affected machines
> (to my knowledge), so I would be very grateful if anyone else can test
> this patch (especially users with Samsung series 5 or 7 machines).
>
> You will need to use a recent kernel source like 3. (one which
> includes the earlier acpi_ec_clear patch), or otherwise apply the
> previous patch first:
>
> https://github.com/torvalds/linux/commit/ad332c8a45330d170bb38b95209de449b31cd1b4.patch
>
> Then apply the attachment ec_process_stale_events.patch
>
> Please test to see if your lid closing / suspending / etc. still work
> as intended with this patch.
>
> This new patch also provides some debug information after every
> resume/boot which will show up in dmesg something like:
>
> [ 1192.208056] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.217844] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.218844] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.222835] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.223834] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.224833] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.227833] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.228834] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.229832] ACPI : EC: acpi_ec_clear: EC_SC 0x28
> [ 1192.230828] ACPI : EC: 8 stale EC events cleared
>
> Please report if you get any EC_SC bytes here _other than_ 0x28. I
> only get 0x28 on my machine but I am very interested to know if other
> affected machines produce something else.
>
> If you test it, please also report your system's product code, e.g.:
>
> # dmidecode -s system-product-name
> 900X3F
> # dmidecode -s baseboard-product-name
> NP900X3F-K01AU
>
> Many thanks,
> Kieran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

