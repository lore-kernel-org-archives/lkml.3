Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3CLKoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:44:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16237 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3CLKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:43:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 03:43:51 -0700
Message-ID: <513F06DF.3040105@nvidia.com>
Date: Tue, 12 Mar 2013 19:43:43 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
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
        Marcelo Tosatti <marcelo@kvack.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 09/17] sh: replace CONFIG_GENERIC_GPIO by CONFIG_GPIOLIB
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <1363083150-30964-10-git-send-email-acourbot@nvidia.com> <20130312103515.GD3553@linux-sh.org>
In-Reply-To: <20130312103515.GD3553@linux-sh.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 07:35 PM, Paul Mundt wrote:
> On Tue, Mar 12, 2013 at 07:12:22PM +0900, Alexandre Courbot wrote:
>> SH GPIO drivers all use gpiolib and CONFIG_GENERIC_GPIO is only selected
>> through CONFIG_GPIOLIB, yet some compilation units depended on
>> CONFIG_GENERIC_GPIO. Make them depend on CONFIG_GPIOLIB instead since it
>> is more accurate and prepares us for the future removal of
>> CONFIG_GENERIC_GPIO.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Note that the bulk of the GENERIC_GPIO use for SH has shifted to
> drivers/pinctrl/sh-pfc/. If GPIOLIB is forced then a good chunk of the
> Kconfig/Makefile bits there ought to be refactored too.

Yes, that is the case for many other drivers actually. This series just 
makes sure that GENERIC_GPIO is set through GPIOLIB *only*, thus making 
both options equivalent. If nobody shoots me for this, I will refactor 
individual drivers and ultimately remove GENERIC_GPIO completely.

Alex.

