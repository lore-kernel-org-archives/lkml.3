Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaCALwI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 06:52:08 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52514 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaCALwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 06:52:06 -0500
Message-ID: <5311CA14.6080009@kernel.org>
Date: Sat, 01 Mar 2014 11:52:52 +0000
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
Subject: Re: [RFCv4 0/7] Convert twl4030-madc to IIO API and add DT support
References: <1393374270-20079-1-git-send-email-sre@debian.org> <1393444990-28140-1-git-send-email-sre@debian.org>
In-Reply-To: <1393444990-28140-1-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 20:03, Sebastian Reichel wrote:
> Hi,
>
> This is RFCv4 for converting twl4030-madc to the IIO API and
> adding DT support. The patchset compiles and has been tested
> on my Nokia N900.
>
> Changes since RFCv3 [0]:
>   * Added Acked-by from Lee Jones (MFD subsystem maintainer)
>     to twl_i2c_read/write_u16 patches
>   * Fixed style issues found by Lee Jones
>     This readded the temp variable Jonathan Cameron wanted to
>     be removed, but makes the code cleaner - especially once
>     the brackets for math for clarity are added.
>   * Tested with converted rx51-battery driver on Nokia N900,
>     which can be found at [1].
>
> [0] https://lkml.org/lkml/2014/2/25/627
> [1] https://lkml.org/lkml/2014/2/25/639

Hi All,

Obviously there are a few outstanding bits and pieces to be addressed.

To get this lined up for a merge...

Lee, do you want to take this through mfd or shall I take it through
IIO?  I don't mind either way.  It stands pretty separate in IIO so
shouldn't cause any merge issues beyond minor fuzz.

Jonathan
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
>   drivers/{mfd => iio/adc}/twl4030-madc.c            | 281 +++++++++++++--------
>   drivers/mfd/Kconfig                                |  10 -
>   drivers/mfd/Makefile                               |   1 -
>   include/linux/i2c/twl.h                            |  12 +
>   include/linux/i2c/twl4030-madc.h                   |   2 +-
>   8 files changed, 227 insertions(+), 114 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
>   rename drivers/{mfd => iio/adc}/twl4030-madc.c (77%)
>

