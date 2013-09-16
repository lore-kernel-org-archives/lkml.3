Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3IPIRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:17:30 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:56490 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3IPIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:17:28 -0400
Date: Mon, 16 Sep 2013 09:17:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 25/38] iio: pressure-core: st: Allow for number of
 channels to vary
Message-ID: <20130916081724.GD3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-26-git-send-email-lee.jones@linaro.org>
 <52349A4E.10401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52349A4E.10401@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Sep 2013, Jonathan Cameron wrote:

> On 09/10/13 13:49, Lee Jones wrote:
> > At the moment the number of channels specified is dictated by the first
> > sensor supported by the driver. As we add support for more sensors this
> > is likely to vary. Instead of using the ARRAY_SIZE() of the LPS331AP's
> > channel specifier we'll use a new adaptable 'struct st_sensors' element
> > instead.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Applied with Denis ack (again it should have been here)

Ah, you're going to take the patches one-by-one?

After amending the drivers as per your review I was going to send a
final time with all Acks applied. Then, once all maintainer Acks were
obtained I was going to send you a pull-request.

Perhaps I should have communicated the intent sooner.

Future submissions will have all Acks applied in this case.

> > ---
> >  drivers/iio/pressure/st_pressure_core.c | 3 ++-
> >  include/linux/iio/common/st_sensors.h   | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> > index 60c2ee4..3abada2 100644
> > --- a/drivers/iio/pressure/st_pressure_core.c
> > +++ b/drivers/iio/pressure/st_pressure_core.c
> > @@ -107,6 +107,7 @@ static const struct st_sensors st_press_sensors[] = {
> >  			[0] = LPS331AP_PRESS_DEV_NAME,
> >  		},
> >  		.ch = (struct iio_chan_spec *)st_press_lps331ap_channels,
> > +		.num_ch = ARRAY_SIZE(st_press_lps331ap_channels),
> >  		.odr = {
> >  			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
> >  			.mask = ST_PRESS_LPS331AP_ODR_MASK,
> > @@ -245,7 +246,7 @@ int st_press_common_probe(struct iio_dev *indio_dev,
> >  	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
> >  	pdata->multiread_bit = pdata->sensor->multi_read_bit;
> >  	indio_dev->channels = pdata->sensor->ch;
> > -	indio_dev->num_channels = ARRAY_SIZE(st_press_lps331ap_channels);
> > +	indio_dev->num_channels = pdata->sensor->num_ch;
> >  
> >  	if (pdata->sensor->fs.addr != 0)
> >  		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
> > diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
> > index e51f654..e732fda 100644
> > --- a/include/linux/iio/common/st_sensors.h
> > +++ b/include/linux/iio/common/st_sensors.h
> > @@ -184,6 +184,7 @@ struct st_sensors {
> >  	u8 wai;
> >  	char sensors_supported[ST_SENSORS_MAX_4WAI][ST_SENSORS_MAX_NAME];
> >  	struct iio_chan_spec *ch;
> > +	int num_ch;
> >  	struct st_sensor_odr odr;
> >  	struct st_sensor_power pw;
> >  	struct st_sensor_axis enable_axis;
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
