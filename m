Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaGZTsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:48:43 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:64712 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaGZTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140703230113.GR3705@n2100.arm.linux.org.uk>
References: <1404420564-30245-1-git-send-email-marek@goldelico.com>
	<20140703230113.GR3705@n2100.arm.linux.org.uk>
Date: Sat, 26 Jul 2014 21:48:38 +0200
Message-ID: <CAAfyv34tH-A=9vjis3_y613mNpvGGO2O82M9porWJwms9-PFFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: hsmmc: Add reset gpio configuration option.
From: Belisko Marek <marek.belisko@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        balajitk@ti.com, chris@printf.net,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mmc@vger.kernel.org,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

On Fri, Jul 4, 2014 at 1:01 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 03, 2014 at 10:49:23PM +0200, Marek Belisko wrote:
>> From: NeilBrown <neilb@suse.de>
>>
>> If a 'gpio_reset' is specified, then hold it low while
>> turning the power regulator on.
>> This is needed for some wi2wi wireless modules, particularly
>> when the regulator is held active by some other client.
>> The wi2wi needs to be reset if power isn't actually removed, and
>> the gpio can be used to do this.
>>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>
> Obvious statement knowing what's been going on elsewhere...
>
> A while back, Olof produced a couple of patches to add /generic/ support
> to deal with power and reset controls for SDIO WIFI cards.  Patches
> were posted to linux-arm-kernel and other places around January time
> this year.
>
> No real conclusion came out of it, and it kind of died.  The point here
> is that this is not an OMAP problem.  We have this very same problem
> on different platforms and different SoCs.
Thanks for pointing me to Olof's patches. I pick first + update secod
for omap_hcmmc.
I use only card-reset-gios property and it works fine. As you stated
it's kind of died discussion?
Sorry for noise and not using more googling on linux-arm ML.
>
> Why should we have N different solutions to the same problem.  Why can't
> we have one solution to fix this issue, rather than having every host
> driver implement some different solution to what's a common problem.
>
> If everyone is going to run away from generic problems and continue
> inventing their own private solutions to generic problems, the kernel
> is just going to become severely bloated and unmaintainable...
>
> Please, sort out generic problems with generic solutions.
>
> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
