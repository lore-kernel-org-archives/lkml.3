Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3IPIFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:05:51 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41417 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3IPIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:05:50 -0400
Date: Mon, 16 Sep 2013 09:05:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 32/38] iio: accel-core: st: Move LSM303DLH into correct
 group
Message-ID: <20130916080546.GC3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-33-git-send-email-lee.jones@linaro.org>
 <5234A20F.7040008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5234A20F.7040008@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Sep 2013, Jonathan Cameron wrote:

> On 09/10/13 13:49, Lee Jones wrote:
> > The LSM303DLH's WAI (WhoAmI) is 0x33, meaning it should be enabled by
> > Accel Sensor group one. For the device to probe without error, we'll
> > need to ensure it's registered with the correct WAI.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> You clearly have a better datasheet than I have as for that part it doesn't even claim to
> have the relevant register to read a who am I from.
> 
> Now that datasheet does list odr values as 50, 100, 400 1000 which would put it where it originally
> was in these tables.
> 
> http://www.st.com/web/en/resource/technical/document/datasheet/CD00260288.pdf
> 
> I haven't checked other elements...
> 
> I'm confused but suspect we may need another type entry to deal with this one.

Hmmm... on initial thought, I don't know how we can handle this one. I
assumed the WAIs were a one-stop-shop for device identification. I also
thought that they would only match if the functionality and register
maps would be the same.

I'll touch base with Denis on this, perhaps he can shed some light.

> > ---
> >  drivers/iio/accel/st_accel_core.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
> > index ea62291..03a2b6b 100644
> > --- a/drivers/iio/accel/st_accel_core.c
> > +++ b/drivers/iio/accel/st_accel_core.c
> > @@ -170,6 +170,7 @@ static const struct st_sensors st_accel_sensors[] = {
> >  			[2] = LSM330D_ACCEL_DEV_NAME,
> >  			[3] = LSM330DL_ACCEL_DEV_NAME,
> >  			[4] = LSM330DLC_ACCEL_DEV_NAME,
> > +			[5] = LSM303DLH_ACCEL_DEV_NAME,
> >  		},
> >  		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
> >  		.odr = {
> > @@ -238,8 +239,7 @@ static const struct st_sensors st_accel_sensors[] = {
> >  		.sensors_supported = {
> >  			[0] = LIS331DLH_ACCEL_DEV_NAME,
> >  			[1] = LSM303DL_ACCEL_DEV_NAME,
> > -			[2] = LSM303DLH_ACCEL_DEV_NAME,
> > -			[3] = LSM303DLM_ACCEL_DEV_NAME,
> > +			[2] = LSM303DLM_ACCEL_DEV_NAME,
> >  		},
> >  		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
> >  		.odr = {
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
