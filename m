Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbbAOBHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:07:19 -0500
Received: from smtp1s1.overthewire.com.au ([203.18.94.100]:55504 "EHLO
	smtp1s1.overthewire.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbbAOBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:07:17 -0500
Message-ID: <54B712C0.5010808@opengear.com>
Date: Thu, 15 Jan 2015 11:07:12 +1000
From: Ken Wilson <ken.wilson@opengear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: thomas.petazzoni@free-electrons.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ezequiel.garcia@free-electrons.com, gerg@uclinux.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] spi: orion: Add multiple chip select support to
 spi-orion
References: <1421032440-15335-1-git-send-email-ken.wilson@opengear.com> <1421032440-15335-3-git-send-email-ken.wilson@opengear.com> <20150114200626.GN3043@sirena.org.uk>
In-Reply-To: <20150114200626.GN3043@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15/01/15 06:06, Mark Brown wrote:
> On Mon, Jan 12, 2015 at 01:14:00PM +1000, Ken Wilson wrote:
>
>> +- num-cs     : The total number of chip selects used by this platform.
>> +		If unset, this defaults to 1.
> So, this is intended to be the number of hardware chip selects that can
> be configured but the first commit mentioned GPIOs as an option too so
> we should at least say that this is specifically the controller
> supported ones.  However...
>
>> +#define ORION_SPI_CS_MASK	0x1C
>> +#define ORION_SPI_CS_SHIFT	2
>> +#define ORION_SPI_CS(cs)	((cs << ORION_SPI_CS_SHIFT) & \
>> +					ORION_SPI_CS_MASK)
> ...given that we have a fixed bitfield here which we know and doesn't
> appear to depend on configuration do we even need this to be
> configurable - given that we're going to need an explicit node for any
> slave can't we just accept any sane chip select for a slave without
> extending the binding?
The different implementations that use this driver (Marvell Kirkwood, 
Armada 370/375) all
have a different number of supported chip selects, that fit into this 
bit mask. There are also
multiple SPI controllers on each SoC which support different numbers of 
chip selects.
For example, on the Armada 375, SPI0 supports 3 chip selects, while SPI1 
only has 1.

I agree that we could support any sane chip select for a slave, since 
the slave addresses do need
to be explicitly defined. I'm happy with whatever your preference is.

Thanks,
Ken
