Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3JKLDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:03:08 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:12805 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3JKLDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:03:06 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+g9Pvwo0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <5257CE55.3090902@ti.com>
Date: Fri, 11 Oct 2013 13:03:04 +0200
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EE1A4C44-B5B2-4309-B362-EFE226F4DB88@goldelico.com>
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de> <5257815F.5070803@ti.com> <5257A402.5030806@metafoo.de> <5570E6D7-4F66-40BE-A50C-6CCA8074BD83@goldelico.com> <5257B420.10808@ti.com> <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com> <5257BFA3.9090202@metafoo.de> <B8F44C8A-362C-4E78-BE91-D9C0783B998B@goldelico.com> <5257CE55.3090902@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am 11.10.2013 um 12:09 schrieb Tomi Valkeinen:

> On 11/10/13 12:50, Dr. H. Nikolaus Schaller wrote:
> 
>> Hm. Is this a SPI or does it just look like one? Or is it some - otherwise
>> unknown - "3 wire serial interface". Or is it a "3(+1) GPIO slave device"?
>> I am still not sure about this.
> 
> Lars-Peter said "Back in the OpenMoko days we used the panel in normal
> 4-wire SPI mode with the GPIO bitbang SPI master."
> 
> I don't know much about SPI, so I can't answer to that. If the serial
> bus is indeed not any kind of more or less standard SPI version, but
> really a custom bus for this controller, then the case is a bit unclear.

I have thought over lunch time that it is worth to look into how the Openmoko
did physically hook up the display and if parts of that code (it was for 2.6.26
or so and for a Samsung SoC) is understandable and reusable (e.g. hints
how to set up the board file for a bitbang SPI on OMAP3 - we have never
done this before).

> 
>> If we really want to do it correctly, we may have to write a driver for that
>> special serial protocol as well. If it turns out that we can't mis-use and tweak
>> it into a standard SPI driver with bit-bang backend.
>> 
>> I simply fear that we get dependencies with the SPI subsystem and have
>> to test, debug and maintain it. Maintaining the GPIO thing we currently have
>> is easy.
>> 
>> What would be against taking the GPIO approach first and then upgrade as soon
>> as someone raises his/her finger that he/she wants to really interface this display
>> differently and is not happy with the 3/4 GPIOs? Either they come up with a patch
>> or contact the driver author (=me).
> 
> I don't have anything against that as long as we use only platform data.
> 
> But DT data is not an in-kernel API, it's an external API. Once we
> define that the DT data for this panel is something, that's it, we
> should stick to it. Of course, we can build compatibility layers for old
> DT data, but I would avoid that if at all possible.

Ah, I see. I already think that using the DT makes such things not easier
but more difficult - but I am not at all familiar with it.

> If we now create the DT data with gpios, and the panel as platform
> device, it'd be rather nasty change to make it a child of an spi bus. (I
> presume, I have never made such a change).
> 
> And, as the gpios and platform device approach is clearly wrong way to
> describe the hardware, I'm quite against using that description in the
> DT data.

Since we are not familiar with DT yet, it is difficult to see the consequences
of such a step.

> That said, one option is to describe the hardware correctly in the DT
> data, but have a platform device for the panel, with panel driver doing
> the bitbanging. In that case it is possible to update the system to use
> SPI framework if needed, without changing the DT data. However, I'm not
> sure how easy that would be.

Sounds quite complex, indeed.

So our next step will be to look into the GTA02 SPI thing to get more knowlegde
about thier solution.

BR,
Nikolaus

