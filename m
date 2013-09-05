Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935806Ab3IELkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:40:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54088 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637Ab3IELkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:40:13 -0400
Message-ID: <1378381209.24019.21.camel@hornet>
Subject: Re: [PATCH] Documentation: dt: i2c: Add LPS001WP to the Trivial
 Devices list
From: Pawel Moll <pawel.moll@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Lee Jones <lee.jones@linaro.org>, "sa@the-dreams.de" <sa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Date: Thu, 05 Sep 2013 12:40:09 +0100
In-Reply-To: <20130905113001.GR18206@e106331-lin.cambridge.arm.com>
References: <1378302655-13258-1-git-send-email-lee.jones@linaro.org>
	 <20130904142422.GM18206@e106331-lin.cambridge.arm.com>
	 <20130904151159.GA8980@lee--X1>
	 <20130905113001.GR18206@e106331-lin.cambridge.arm.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Sep 2013 11:40:10.0135 (UTC) FILETIME=[AD322270:01CEAA2C]
X-MC-Unique: 113090512401004201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 12:30 +0100, Mark Rutland wrote:
> I also note that the device can also be attached to SPI. Do we have any
> other devices which may be attached to either? Do we handle that, and if
> so, how (do we have the same compatible string for both interfaces?)?

Theoretically you don't need anything to make it work - nodes being a
children of a I2C master will instantiate i2c_clients, offspring of a
SPI master will become spi_devices. Then you register two drivers - I2C
and SPI ones, probably sharing most of the code - both matching the same
compatible value. The I2C one will be bound only with the I2C nodes, the
same applies to SPI.

I hope :-)

Paweł


