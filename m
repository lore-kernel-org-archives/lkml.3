Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3JKJFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:05:00 -0400
Received: from smtp-out-230.synserver.de ([212.40.185.230]:1052 "EHLO
	smtp-out-230.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JKJE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:04:57 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7517
Message-ID: <5257BFA3.9090202@metafoo.de>
Date: Fri, 11 Oct 2013 11:06:43 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de> <5257815F.5070803@ti.com> <5257A402.5030806@metafoo.de> <5570E6D7-4F66-40BE-A50C-6CCA8074BD83@goldelico.com> <5257B420.10808@ti.com> <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com>
In-Reply-To: <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 10:59 AM, Belisko Marek wrote:
> Hi Tomi,
> 
> On Fri, Oct 11, 2013 at 10:17 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>> On 11/10/13 10:42, Dr. H. Nikolaus Schaller wrote:
>>
>>> I am not sure if there is a SPI driver for a McBSP port [1]? And to make that
>>> work (reliably) and tested it might need a lot of work for us. At least I think
>>> such a change (e.g. setting up clock polarity etc.) is not done in some minutes.
>>> And the only feedback we have from the panel is "does not work"/"works". I.e.
>>> if we are not lucky that it works immediately we have no real means to debug.
>>>
>>> IMHO it also gives more flexibility to board designers to choose GPIOs instead
>>> of enforcing some SPI interface by the driver (and encapsulate this arguable
>>> protocol in the driver). Maybe some board has 3 spare GPIOs but neither
>>> McBSPs nor McSPIs available.
>>
>> This has been an interesting thread, I've learnt a lot =).
>>
>> I still think the panel driver should not handle this, but there should
>> be a separate spi bitbang driver for it.
>>
>> I understand you're not enthusiastic going that way, as the current
>> version works for you. However, when using DT, we need to think how to
>> represent the hardware in the device tree data, and it has to be right
>> from the beginning.
>>
>> That's why I won't allow representing this panel as having 4 gpios in
>> the DT data, because that is not correct. The panel has 3 pins. But
>> then, the panel does allow reading, which could be implemented using 4
>> gpios as you have done. This data should be in the spi-bitbang data, and
>> the panel should just use the standard SPI framework.
> I disagree. There are different drivers which pass in platform data
> gpios (encoder-tfp410.c or encoder-tpd12s015.c)
> and those must be covered by DT then. I cannot see problem why to have
> for td028 panel 3 or 4 gpios defined in DT.

The problem is not representing it in the devicetree, but representing it
correctly. This is a SPI slave device, hence it should be presented in the
devicetree as a SPI slave device and not as a platform device with 4 GPIOs.

- Lars

