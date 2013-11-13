Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab3KMSkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:40:17 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49686 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329Ab3KMSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <5283B83A.8030206@gmail.com>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
	<1384285347-13506-15-git-send-email-geert@linux-m68k.org>
	<5283A000.8090007@gmail.com>
	<CAMuHMdU6Lqup-MuAOH0iTg16b-SHw4D52WsoPXMsumOxQWbJrg@mail.gmail.com>
	<5283B83A.8030206@gmail.com>
Date: Wed, 13 Nov 2013 19:40:08 +0100
X-Google-Sender-Auth: HoIOaEjrMj4i9nmuCQhnbnW2j5Y
Message-ID: <CAMuHMdWG+cVGzWeivm43r_AaemoHk=YmQ_vc+t+B28KG27TaVg@mail.gmail.com>
Subject: Re: [PATCH 14/17] dt: Consolidate __dtb_start declarations in <linux/of_fdt.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 6:34 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> +       if (!initial_boot_params ||
>>> +           (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER))
>>> +               initial_boot_params = &__dtb_start;
>>> +
>>>         /* check device tree validity */
>>> -       if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
>>> +       if (!initial_boot_params ||
>>
>> initial_boot_params cannot be NULL here, so no need to check.
>
> What about the case of no built-in dtb like on arm?

Even then the symbol exists, as all architectures put INIT_DATA or
INIT_DATA_SECTION in their vmlinux.lds.S.
But the section will be empty, cfr. the case __dtb_end == __dtb_start below.

>>
>>> +           (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER)) {
>>
>> However, if __dtb_end == __dtb_start, you may be reading random
>> data here from the next section. The OF_DT_HEADER check should cover
>> this, but better safe than sorry?
>
> Then we should also check that (__dtb_end != __dtb_start).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
