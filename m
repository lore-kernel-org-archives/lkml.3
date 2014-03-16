Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaCPRpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:45:53 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39242 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaCPRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:45:51 -0400
Message-ID: <5325E387.3040503@kernel.org>
Date: Sun, 16 Mar 2014 17:46:47 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv4 0/7] Convert twl4030-madc to IIO API and add DT support
References: <1394934211-21605-1-git-send-email-sre@debian.org>
In-Reply-To: <1394934211-21605-1-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

I'm happy with whole lot and looks like you are as well.
The only outstanding delaying element I can see is the lack
of a device tree ack. That patch has been the same for over
a month though....

Lots more possible cleanup in this driver though for Sebastian
or anyone else to take on when they are bored!

Jonathan

On 16/03/14 01:43, Sebastian Reichel wrote:
> Hi,
>
> This is PATCHv4 for converting twl4030-madc to the IIO API and
> adding DT support. The plan is to remove the private twl4030-madc
> API once all users have been removed or converted to the IIO API.
> The patchset compiles and has been tested on my Nokia N900.
>
> Changes since PATCHv3 [0]:
>   * Dropped the following patches (applied in iio tree)
>    - iio: documentation: Add ABI documentation for *_mean_raw
>    - iio: inkern: add iio_read_channel_average_raw
>   * Added some more Acked-by from Jonathan Cameron
>    - one of them on the basis of "Reorder that and I'm happy".
>   * Changed some minor stuff requested by Jonathan
>    - reorder cleanup calls in driver's remove function
>    - convert another comment to kerneldoc
>
> Status:
>   * Only feedback from DT binding maintainers is missing.
>     side note: The binding & the corresponding binding documentation
>     patch has not changed since 2014-02-13. So depending on when the
>     time frame starts the three weeks are over already ;)
>   * It would be nice to see this patchset in 3.15.
>
> [0] https://lkml.org/lkml/2014/3/10/727
>
> -- Sebastian
>
> Sebastian Reichel (7):
>    mfd: twl4030-madc: Use managed resources
>    mfd: twl4030-madc: Add DT support and convert to IIO framework
>    mfd: twl4030-madc: Cleanup driver
>    mfd: twl-core: Add twl_i2c_read/write_u16
>    mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
>    Documentation: DT: Document twl4030-madc binding
>    mfd: twl4030-madc: Move driver to drivers/iio/adc
>
>   .../devicetree/bindings/iio/adc/twl4030-madc.txt   |  24 ++
>   drivers/iio/adc/Kconfig                            |  10 +
>   drivers/iio/adc/Makefile                           |   1 +
>   drivers/{mfd => iio/adc}/twl4030-madc.c            | 320 +++++++++++++--------
>   drivers/mfd/Kconfig                                |  10 -
>   drivers/mfd/Makefile                               |   1 -
>   include/linux/i2c/twl.h                            |  12 +
>   include/linux/i2c/twl4030-madc.h                   |   2 +-
>   8 files changed, 247 insertions(+), 133 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
>   rename drivers/{mfd => iio/adc}/twl4030-madc.c (74%)
>

