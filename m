Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaLOKAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:00:19 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52024 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaLOKAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:00:15 -0500
Date: Mon, 15 Dec 2014 11:02:13 +0100
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v2 2/2] iio: add driver for the TI DAC8554
Message-ID: <20141215100213.GA6159@avionic-0071.adnet.avionic-design.de>
References: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de>
 <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de>
 <5482EA33.7020305@gmx.de>
 <20141212155804.GA1142@avionic-0071.adnet.avionic-design.de>
 <548C209A.7000904@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <548C209A.7000904@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:MDC/pwoJNscaEb7pbNhmXTAtQrTfR/kSBEEW49wwo4athVzWSF/
 qCuicTxVHcPgDBZQNlljkN/NbiNFytfZOXpqmJUpis55mn7CtQtUbzkwzpLe2mlR7w0ToJa
 QhZ6LH6N02l0HHPPpoE22aenMhgnNo+p37B6D6Cp6M0FOYfnRloow9xh5xuKkn1ZZkfQGdu
 B+NWVsGsjuMFgVegmxBlA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 12:18:50PM +0100, Hartmut Knaack wrote:
> Nikolaus Schulz schrieb am 12.12.2014 um 16:58:
> > On Sat, Dec 06, 2014 at 12:36:19PM +0100, Hartmut Knaack wrote:
> >> Nikolaus Schulz schrieb am 24.11.2014 um 20:50:
> >>> The TI DAC8554 is a quad-channel Digital-to-Analog Converter with an SPI
> >>> interface.
[dac8554_probe:]
> >>> +	st->vref_mv =oltage_uv / 1000;
> >> How hard do you want to depend on a voltage regulator? Doing regulator_get_voltage()
> >> could even be called dynamically in _read_raw(), making a real regulator optional.
> > 
> > Hmm. I understand that the DAC voltage input may not be provided by a
> > regulator, but is that a common scenario?  No other DAC driver I looked
> > at handles that case, they all consider it an error if the regulator is
> > absent.
> > 
> I had people in mind, who might want to use such DAC with one of the popular
> embedded boards like Raspberry Pi - people who would just like to "plug and
> play" without the need or ability to build a kernel (or would prefer to go
> with the convenience of a distribution kernel). But since you've put a
> dependency on OF, I don't see a way to use this device with a stock distribution
> kernel anyway.

As long as the kernel supports devicetree, compiling the module and a
new DT blob should be enough to enable support for the DAC8554.

And, as Jonathan has pointed out, if there is no real regulator
providing the input current, a fixed regulator can be added to the DT.

> But I still think that calculating the actual voltage during _read_raw() would
> be a good idea, as there is support for regulators providing different voltages,
> which can be changed during runtime.

Agreed.

-- 
Avionic Design GmbH
Nikolaus Schulz
Wragekamp 10
D-22397 Hamburg
Germany

Tel.:  +49 40 88187-163
Fax:   +49 40 88187-150
Email: nikolaus.schulz@avionic-design.de

Avionic Design GmbH
Amtsgericht Hamburg HRB 82598
Geschäftsführung: Cornelis Broers
Ust.-Ident-Nr.: DE813378254
