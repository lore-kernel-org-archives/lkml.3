Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaEZLIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:08:41 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53516 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaEZLIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:08:39 -0400
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
Date: Mon, 26 May 2014 14:08:32 +0300
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BA47464B-B724-4D41-8D82-1A8880E310E9@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com> <1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com> <20140514100856.5198DC4153D@trevor.secretlab.ca> <E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com> <CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com> <20140516105814.3EA3FC403C2@trevor.secretlab.ca> <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com> <20140520055026.E3A98C412DA@trevor.secretlab.ca> <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com> <20140526104824.63F13C42129@trevor.secretlab.ca> <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On May 26, 2014, at 1:57 PM, Geert Uytterhoeven wrote:

> Hi Grant,
> 
> On Mon, May 26, 2014 at 12:48 PM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
>> On Tue, 20 May 2014 09:38:49 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Tue, May 20, 2014 at 7:50 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>>>> Why has the overlay system been designed for plugging and unpluging whole
>>>>> overlays?
>>>>> That means the kernel has to remember the full stack, causing issues with
>>>>> e.g. kexec.
>>>> 
>>>> Mostly so that drivers don't see any difference in the livetree data
>>>> structure. It also means that userspace sees a single representation of
>>>> the hardware at any given time.
>>> 
>>> Sorry, I don't follow the argument about the "single representation of the
>>> hardware".
>> 
>> Er, s/of the hardware/of the tree/. Right now the overlay design
>> modifies the live tree which at the same time modifies the tree
>> representation in /sys/firmware/devicetree. If the design was changed to
>> keep the overlay logically separate, then I would think we want to
>> expose that information to usespace also. In fact, I think we would need
>> to for usecases like kexec.
> 
> OK, so it does modify the real tree, and doesn't keep the actual overlays.
> 

It modifies the actual tree, and it keeps a log of each modification made to the
tree so that it will be able to revert the changes made.

> I was under the impression the overlay stack was also kept in memory, to allow
> reversal, so there was a misunderstanding.
> 

Yep.

> Hence for kexec, the tree in /sys/firmware/devicetree can just be passed
> to the new kernel, as that's the current representation of the hardware?
> 

Exactly.

> Gr{oetje,eeting}s,
> 
>                        Geert
> 

Regards

-- Pantelis

> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

