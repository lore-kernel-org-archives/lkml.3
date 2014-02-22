Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBVMti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 07:49:38 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54003 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaBVMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 07:49:36 -0500
Message-ID: <53089D09.1020203@kernel.org>
Date: Sat, 22 Feb 2014 12:50:17 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Ranostay <mranostay@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org
CC: matt.porter@linaro.org, pantelis.antoniou@gmail.com
Subject: Re: [PATCH v7 0/2] AS3935 lightning sensor support
References: <1392179475-2611-1-git-send-email-mranostay@gmail.com>
In-Reply-To: <1392179475-2611-1-git-send-email-mranostay@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a quick note to say I'm hold off on this in the hope for some
feedback on my suggested interface for position devices that I sent
in response to the previous version.  I think lumping these under
proximity devices is the wrong approach as that doesn't generalize well.


On 12/02/14 04:31, Matt Ranostay wrote:
> This series adds support for the AMS AS3935 lightning sensor that allows
> reporting back estimated storm distance and strike events.
>
> Chagges from v6
>
> * Revised binding documents to not use the term "interrupts mapping"
> * Renamed tune-cap property to a more clear tuning-capacitor-pf
>
> Changes from v5
>
> * SPI write cache-aligned issues fixed
> * Fixed mutex_unlock's being missed
> * Reports distance in meters instead of kilometers (1km steps)
> * tune_cap is now in picofarads and not a register value
>
> Matt Ranostay (2):
>    iio:as3935: Add DT binding docs for AS3935 driver
>    iio: Add AS3935 lightning sensor support
>
>   .../ABI/testing/sysfs-bus-iio-proximity-as3935     |  18 +
>   .../devicetree/bindings/iio/proximity/as3935.txt   |  28 ++
>   .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>   drivers/iio/Kconfig                                |   1 +
>   drivers/iio/Makefile                               |   1 +
>   drivers/iio/proximity/Kconfig                      |  19 +
>   drivers/iio/proximity/Makefile                     |   6 +
>   drivers/iio/proximity/as3935.c                     | 446 +++++++++++++++++++++
>   8 files changed, 520 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
>   create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt
>   create mode 100644 drivers/iio/proximity/Kconfig
>   create mode 100644 drivers/iio/proximity/Makefile
>   create mode 100644 drivers/iio/proximity/as3935.c
>

