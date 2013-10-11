Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab3JKJvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:51:04 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:50927 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3JKJvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:51:00 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+g9Pvwo0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <5257BFA3.9090202@metafoo.de>
Date: Fri, 11 Oct 2013 11:50:55 +0200
Cc: Belisko Marek <marek.belisko@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B8F44C8A-362C-4E78-BE91-D9C0783B998B@goldelico.com>
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de> <5257815F.5070803@ti.com> <5257A402.5030806@metafoo.de> <5570E6D7-4F66-40BE-A50C-6CCA8074BD83@goldelico.com> <5257B420.10808@ti.com> <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com> <5257BFA3.9090202@metafoo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Am 11.10.2013 um 11:06 schrieb Lars-Peter Clausen:

> On 10/11/2013 10:59 AM, Belisko Marek wrote:
>> Hi Tomi,
>> 
>> On Fri, Oct 11, 2013 at 10:17 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>> On 11/10/13 10:42, Dr. H. Nikolaus Schaller wrote:
>>> 
>>>> I am not sure if there is a SPI driver for a McBSP port [1]? And to make that
>>>> work (reliably) and tested it might need a lot of work for us. At least I think
>>>> such a change (e.g. setting up clock polarity etc.) is not done in some minutes.
>>>> And the only feedback we have from the panel is "does not work"/"works". I.e.
>>>> if we are not lucky that it works immediately we have no real means to debug.
>>>> 
>>>> IMHO it also gives more flexibility to board designers to choose GPIOs instead
>>>> of enforcing some SPI interface by the driver (and encapsulate this arguable
>>>> protocol in the driver). Maybe some board has 3 spare GPIOs but neither
>>>> McBSPs nor McSPIs available.
>>> 
>>> This has been an interesting thread, I've learnt a lot =).
>>> 
>>> I still think the panel driver should not handle this, but there should
>>> be a separate spi bitbang driver for it.
>>> 
>>> I understand you're not enthusiastic going that way, as the current
>>> version works for you. However, when using DT, we need to think how to
>>> represent the hardware in the device tree data, and it has to be right
>>> from the beginning.
>>> 
>>> That's why I won't allow representing this panel as having 4 gpios in
>>> the DT data, because that is not correct. The panel has 3 pins. But
>>> then, the panel does allow reading, which could be implemented using 4
>>> gpios as you have done. This data should be in the spi-bitbang data, and
>>> the panel should just use the standard SPI framework.
>> I disagree. There are different drivers which pass in platform data
>> gpios (encoder-tfp410.c or encoder-tpd12s015.c)
>> and those must be covered by DT then. I cannot see problem why to have
>> for td028 panel 3 or 4 gpios defined in DT.
> 
> The problem is not representing it in the devicetree, but representing it
> correctly. This is a SPI slave device, hence it should be presented in the
> devicetree as a SPI slave device and not as a platform device with 4 GPIOs.

Hm. Is this a SPI or does it just look like one? Or is it some - otherwise
unknown - "3 wire serial interface". Or is it a "3(+1) GPIO slave device"?
I am still not sure about this.

If we really want to do it correctly, we may have to write a driver for that
special serial protocol as well. If it turns out that we can't mis-use and tweak
it into a standard SPI driver with bit-bang backend.

I simply fear that we get dependencies with the SPI subsystem and have
to test, debug and maintain it. Maintaining the GPIO thing we currently have
is easy.

What would be against taking the GPIO approach first and then upgrade as soon
as someone raises his/her finger that he/she wants to really interface this display
differently and is not happy with the 3/4 GPIOs? Either they come up with a patch
or contact the driver author (=me).

BR,
Nikolaus

