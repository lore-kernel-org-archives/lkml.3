Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbaGOR5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:57:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:44527 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaGOR5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:57:17 -0400
Message-ID: <53C56C05.5010208@kernel.org>
Date: Tue, 15 Jul 2014 18:59:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>, linux-iio@vger.kernel.org
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: Re: [PATCH v4 0/5] staging:iio:hmc5843: Few adjustments and support
 for hmc5983
References: <20140715122410.GA30770@dashie>
In-Reply-To: <20140715122410.GA30770@dashie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 13:24, Josef Gajdusek wrote:
> This patch series modifies the hmc5843 driver to support the hmc5983 i2c and
> spi interfaces.
>
> v2:
> 	* Reverted the changed order of iio unregister and setting hmc mode to sleep
>
> v3:
> 	* Fixed bug introduced in the first patch
> 	* Readded few comment lines which have gone missing in the hmc5843.c ->
> 	  hmc5843_core.c move
>
> v4:
>      * Changes suggested by Lars in https://lkml.org/lkml/2014/7/14/968
> 	  * The i2c and spi drivers are now user-selectable with the core driver
> 	    being selected automatically
> 	  * The regmap_config structs in both _spi and _i2c files are now static
> 	  * The iio_dev allocation is now done in the common function
> 	  * pm ops are now defined in the header file and the same definition is
> 	    shared between both interface-specific drivers
> 	* regmap tables in hmc5843.h are not longer static (this fixed bunch of
> 	  variable not used warnings)
>
> Jonathan, the patch series applies cleanly against mainline (for me at least),
> maybe you already have some hmc5843 related patches in your tree which are not
> yet in upstream? (probably https://lkml.org/lkml/2014/2/14/312)
You are correct (although curiously the error from patch this time is a much cleaner
fail than before where it was detecting a repeated apply - ah well).
Could you rebase this series against staging/staging-next
from git.kernel.org please.  I'm far more likely to get something wrong doing
this than you are. Also you have the ability to test the result!

Sorry for the extra work but it's good to see lots of simultaneous interest
in this driver!

Thanks,

Jonathan
>
> Josef Gajdusek (5):
>    staging:iio:hmc5843: Added regmap support
>    staging:iio:hmc5843: Split hmc5843.c to multiple files
>    staging:iio:hmc5843: register <-> value arrays now can have different
>      lengths
>    staging:iio:hmc5843: Add support for i2c hmc5983
>    staging:iio:hmc5843: Add support for spi hmc5983
>
>   drivers/staging/iio/magnetometer/Kconfig        |  30 +-
>   drivers/staging/iio/magnetometer/Makefile       |   4 +-
>   drivers/staging/iio/magnetometer/hmc5843.c      | 652 ------------------------
>   drivers/staging/iio/magnetometer/hmc5843.h      |  86 ++++
>   drivers/staging/iio/magnetometer/hmc5843_core.c | 638 +++++++++++++++++++++++
>   drivers/staging/iio/magnetometer/hmc5843_i2c.c  |  74 +++
>   drivers/staging/iio/magnetometer/hmc5843_spi.c  |  73 +++
>   7 files changed, 900 insertions(+), 657 deletions(-)
>   delete mode 100644 drivers/staging/iio/magnetometer/hmc5843.c
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843.h
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843_core.c
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843_i2c.c
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c
>

