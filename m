Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3CLNof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:44:35 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33873 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3CLNoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <201303121123.18320.arnd@arndb.de>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <201303121123.18320.arnd@arndb.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 12 Mar 2013 22:44:13 +0900
Message-ID: <CAAVeFuLUXrBjHvRugHK5jaKfUOm58LWe_NV=3fmt7Mr1J0yjXw@mail.gmail.com>
Subject: Re: [RFC 00/17] Remove GENERIC_GPIO from architecture code
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 8:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Nice series,
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

>> For most platforms, this change should be a no-op. However I would like to make
>> sure that everyone is ok with it and that nothing gets broken, as the effect of
>> changing configuration options are sometimes difficult to predict.
>
> It's probably worth pointing out which platforms actually change with this. For
> all I can tell, the only user-visible change is that m68k now cannot turn
> off gpiolib any more.

That's the one we are sure is affected indeed. I am also a little bit
worried about blackfin, since it used to compile with GENERIC_GPIO and
patch #15 removes that. However it seems that blackfin's GPIO driver
is unconditionally compiled, so the whole architecture might actually
need ARCH_REQUIRE_GPIOLIB now.

There are also some more subtle changes in mips and arm where I rely
on indirect selection of gpiolib to assume that GENERIC_GPIO will
remain true - it's a bit of a headache, actually. Anyway the arch
maintainers know better what they really need, so I prefer not to
assume too much on my own.

Alex.
