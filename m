Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaCEVAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:00:43 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38124 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaCEVAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:00:40 -0500
MIME-Version: 1.0
In-Reply-To: <1393970751-18157-1-git-send-email-sre@debian.org>
References: <1393702365-26429-1-git-send-email-sre@debian.org>
	<1393970751-18157-1-git-send-email-sre@debian.org>
Date: Wed, 5 Mar 2014 22:00:38 +0100
Message-ID: <CAAfyv360c4UTKUgdYJREgnro1fGLLpGhcHUtdr0q5B6guGvLUQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/9] Convert twl4030-madc to IIO API and add DT support
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Jonathan Cameron <jic23@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 4, 2014 at 11:05 PM, Sebastian Reichel <sre@debian.org> wrote:
> Hi,
>
> This is PATCHv2 for converting twl4030-madc to the IIO API and
> adding DT support. The plan is to remove the private twl4030-madc
> API once all users have been removed or converted to the IIO API.
> The patchset compiles and has been tested on my Nokia N900.
>
> Changes since PATCHv1 [0]:
>  * Fix warning about unused variable
>  * Add IIO_CHAN_INFO_PROCESSED to all channels, since voltage
>    channels also need some postprocessing
>
> TODO:
>  * Wait for feedback from DT binding maintainers
>  * Wait for feedback from Marek Belisko, who is testing the
>    changes with twl4030-madc-battery driver on GTA04
Tested on gta04 board. Works as expected with twl4030_madc_battery patches [1]
on top. So you can add my Tested-by: Marek Belisko <marek@goldelico.com>
>
> [0] https://lkml.org/lkml/2014/3/1/105
>
> -- Sebastian
>
> Sebastian Reichel (9):
>   mfd: twl4030-madc: Use managed resources
>   mfd: twl4030-madc: Add DT support and convert to IIO framework
>   mfd: twl4030-madc: Cleanup driver
>   mfd: twl-core: Add twl_i2c_read/write_u16
>   mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
>   Documentation: DT: Document twl4030-madc binding
>   mfd: twl4030-madc: Move driver to drivers/iio/adc
>   iio: documentation: Add ABI documentation for *_mean_raw
>   iio: inkern: add iio_read_channel_average_raw
>
>  Documentation/ABI/testing/sysfs-bus-iio            |   8 +
>  .../devicetree/bindings/iio/adc/twl4030-madc.txt   |  24 ++
>  drivers/iio/adc/Kconfig                            |  10 +
>  drivers/iio/adc/Makefile                           |   1 +
>  drivers/{mfd => iio/adc}/twl4030-madc.c            | 299 +++++++++++++--------
>  drivers/iio/inkern.c                               |  18 ++
>  drivers/mfd/Kconfig                                |  10 -
>  drivers/mfd/Makefile                               |   1 -
>  include/linux/i2c/twl.h                            |  12 +
>  include/linux/i2c/twl4030-madc.h                   |   2 +-
>  include/linux/iio/consumer.h                       |  13 +
>  11 files changed, 274 insertions(+), 124 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
>  rename drivers/{mfd => iio/adc}/twl4030-madc.c (75%)
>
> --
> 1.9.0
>

[1]: http://www.spinics.net/lists/kernel/msg1700793.html

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
