Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3JKI7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:59:34 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:36308 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3JKI7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:59:30 -0400
MIME-Version: 1.0
In-Reply-To: <5257B420.10808@ti.com>
References: <1381352915-17219-1-git-send-email-marek@goldelico.com>
	<525662F5.3090600@ti.com>
	<7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com>
	<52568B40.4040802@ti.com>
	<04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com>
	<525699EF.6090803@ti.com>
	<52569CE8.5070201@metafoo.de>
	<A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com>
	<5256F8DF.2020801@metafoo.de>
	<5257815F.5070803@ti.com>
	<5257A402.5030806@metafoo.de>
	<5570E6D7-4F66-40BE-A50C-6CCA8074BD83@goldelico.com>
	<5257B420.10808@ti.com>
Date: Fri, 11 Oct 2013 10:59:29 +0200
Message-ID: <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
From: Belisko Marek <marek.belisko@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Fri, Oct 11, 2013 at 10:17 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 11/10/13 10:42, Dr. H. Nikolaus Schaller wrote:
>
>> I am not sure if there is a SPI driver for a McBSP port [1]? And to make that
>> work (reliably) and tested it might need a lot of work for us. At least I think
>> such a change (e.g. setting up clock polarity etc.) is not done in some minutes.
>> And the only feedback we have from the panel is "does not work"/"works". I.e.
>> if we are not lucky that it works immediately we have no real means to debug.
>>
>> IMHO it also gives more flexibility to board designers to choose GPIOs instead
>> of enforcing some SPI interface by the driver (and encapsulate this arguable
>> protocol in the driver). Maybe some board has 3 spare GPIOs but neither
>> McBSPs nor McSPIs available.
>
> This has been an interesting thread, I've learnt a lot =).
>
> I still think the panel driver should not handle this, but there should
> be a separate spi bitbang driver for it.
>
> I understand you're not enthusiastic going that way, as the current
> version works for you. However, when using DT, we need to think how to
> represent the hardware in the device tree data, and it has to be right
> from the beginning.
>
> That's why I won't allow representing this panel as having 4 gpios in
> the DT data, because that is not correct. The panel has 3 pins. But
> then, the panel does allow reading, which could be implemented using 4
> gpios as you have done. This data should be in the spi-bitbang data, and
> the panel should just use the standard SPI framework.
I disagree. There are different drivers which pass in platform data
gpios (encoder-tfp410.c or encoder-tpd12s015.c)
and those must be covered by DT then. I cannot see problem why to have
for td028 panel 3 or 4 gpios defined in DT.
>
> Using SPI framework does not mean you should use McBSP or McSPI. It's up
> to you how the 3-wire SPI is implemented on the SoC side, the panel
> would just work in all the cases.
>
>  Tomi
>
>

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
