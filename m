Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab3CMVPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:15:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63415 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3CMVPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:15:12 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 13 Mar 2013 14:15:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, devicetree-discuss@lists.ozlabs.org,
        Jean Delvare <khali@linux-fr.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH v4] hwmon: ntc: Add DT with IIO support to NTC thermistor
 driver
Message-ID: <20130313211515.GA14632@roeck-us.net>
References: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
 <1363147700-7042-1-git-send-email-ch.naveen@samsung.com>
 <CAD=FV=Wj6=3M+j5jF5xVFJLJS39on48_4gb6XO2uvyVG1pXVbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Wj6=3M+j5jF5xVFJLJS39on48_4gb6XO2uvyVG1pXVbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 01:52:35PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Tue, Mar 12, 2013 at 9:08 PM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
> > This patch adds DT support to NTC driver to parse the
> > platform data.
> >
> > Also adds the support to work as an iio device.
> >
> > During the probe ntc driver gets the respective channels of ADC
> > and uses iio_raw_read calls to get the ADC converted value.
> >
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > ---
> > Changes since v3:
> > 1. Added a NULL check before iio_channel_release
> > 2. Modified a return statement
> >
> > Guenter Roeck, Its wonderful working with you. Thanks.
> >
> >  .../devicetree/bindings/hwmon/ntc_thermistor.txt   |   29 ++++
> >  drivers/hwmon/Kconfig                              |    1 +
> >  drivers/hwmon/ntc_thermistor.c                     |  145 +++++++++++++++++---
> >  include/linux/platform_data/ntc_thermistor.h       |    8 +-
> >  4 files changed, 163 insertions(+), 20 deletions(-)
> 
> I haven't done a full review of this code, but it I built it in (along
> with other CLs to enable it on exynos5250-snow) and the thermistors
> are accessible and report reasonable values.
> 
> localhost hwmon # grep "" /sys/class/hwmon/*/device/temp1_input
> /sys/class/hwmon/hwmon0/device/temp1_input:37890
> /sys/class/hwmon/hwmon1/device/temp1_input:38393
> /sys/class/hwmon/hwmon2/device/temp1_input:37148
> /sys/class/hwmon/hwmon3/device/temp1_input:38059
> 
> Tested-by: Doug Anderson <dianders@chromium.org>
> 
Thanks!

Guenter
