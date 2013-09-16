Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3IPKIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:08:15 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42809 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3IPKIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:08:14 -0400
Date: Mon, 16 Sep 2013 11:08:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Denis CIOCCA <denis.ciocca@st.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 38/38] iio: magn-core: st: Provide support for the
 LSM303DLH
Message-ID: <20130916100809.GI3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
 <5234A28D.1030409@kernel.org>
 <20130916073151.GB3999@lee--X1>
 <5236D03D.2030506@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5236D03D.2030506@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Denis CIOCCA wrote:

> Hi Lee,
> > index 12e7e79..b2e2917 100644
> > --- a/drivers/iio/magnetometer/st_magn_core.c
> > +++ b/drivers/iio/magnetometer/st_magn_core.c
> > @@ -151,7 +151,8 @@ static const struct st_sensors st_magn_sensors[] = {
> >   		.wai = ST_MAGN_1_WAI_EXP,
> >   		.sensors_supported = {
> >   			[0] = LSM303DLHC_MAGN_DEV_NAME,
> > -			[1] = LSM303DLM_MAGN_DEV_NAME,
> > +			[1] = LSM303DLH_MAGN_DEV_NAME,
> > +			[0] = LSM303DLM_MAGN_DEV_NAME,
> Are you sure that it works?

Well I have tested it working.

> Because LSM303DLH magnetometer use different kind of WAI registers. This 
> driver read 0x0f and in this case the value is 0 and the driver do not 
> probe...You have to read the identification registers (0x0a, 0x0b, 0x0c) 
> in that case.

The driver mentions that the first group of sensors have a WAI of 0x3c:

  #define ST_MAGN_1_WAI_EXP    0x3c

And when I print out the WAI read from the device: 
  
  Requested device: lsm303dlh_magn - read WAI: 0x3c

I guess I could have been lied to again by the board's datasheet again
and the attached device isn't actually a LSM303DLH, but how can I tell
for sure?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
