Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBWWB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:01:56 -0500
Received: from ring0.de ([5.45.105.125]:59141 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaBWWBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:01:54 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 23 Feb 2014 23:01:40 +0100
From: Sebastian Reichel <sre@debian.org>
To: Jonathan Cameron <jic23@kernel.org>, Marek Belisko <marek@goldelico.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv1 4/4] mfd: twl4030-madc: Move driver to drivers/iio/adc
Message-ID: <20140223220140.GA1258@earth.universe>
References: <20140214174040.GB26969@earth.universe>
 <1392403586-30540-1-git-send-email-sre@debian.org>
 <1392403586-30540-4-git-send-email-sre@debian.org>
 <53089C47.5050404@kernel.org>
 <20140223003504.GA28154@earth.universe>
 <5309D536.9020404@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <5309D536.9020404@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Feb 23, 2014 at 11:02:14AM +0000, Jonathan Cameron wrote:
> On 23/02/14 00:35, Sebastian Reichel wrote:
> >I think the optimal workflow is:
> >
> >1. convert madc driver to IIO
> >2. convert twl4030-madc-battery driver to IIO API
> >3. convert rx51-battery to IIO API
> >4. convert twl4030-madc-hwmon to IIO API / deprecate it
> >5. remove old in-kernel ABI from madc
> >6. cleanup/simplify madc
> >
> >I guess its much simpler to do the driver cleanup/simplification
> >once we can get rid of the old API.
>=20
> Perhaps.  I guess it depends on your planned schedule.  If you are
> intending to plough through the above in the near future then fair
> enough.  If the chances are it'll take a while, I'd be inclined to
> fix some of the more glarringly hideous bits now (such as error
> code reporting) and then visit your list above over time.

I plan to update the rx51-battery driver, since that's the only one
I can test. Actually I only did the changes to the twl4030-madc
driver, so that I can use the standard DT API for AD converters for
rx51-battery. I hope to get it updated ASAP.

Marek seems to work on getting DT support for the other two
consumers (twl4030-madc-battery and twl4030-madc-hwmon), so chances
are, that the old API can be removed in the near future :)

> Note that to my mind it is converted drivers like this that sneak some
> nasty code into an a subsystem I look after.  We have a lot of 'interesti=
ng'
> code out in staging still, but for new submissions we are being increasin=
gly
> fussy about little bits.  So I hope I don't come across as being too mean
> about this driver.  I'm glad you are putting in the work to convert
> it over.  There are a quite a few similar drivers sculking through the tr=
ee
> so it's nice that someone has gotten started on bringing one over to IIO.

If it makes you feel more at ease I will try to forward the errors
and replace the error code with 0 at the end.

> [...]
>
> >>Is the average have an adjustable number of samples?
> >
> >The TWL supports reading a value directly (1 sample) or reading
> >the average of 4 samples.
> >
> >>If not I'd be tempted to use the more common option of IIO_CHAN_INFO_RAW
> >>rather than the average version (tends only to be used in fairly obscure
> >>cases where both a raw access and an averaged one are available).
> >
> >currently some drivers use the averaged read and some use the direct
> >read.
> >
>=20
> In that case I'd expose both the 1 sample and averaged versions via the
> IIO interfaces. If you want to pick 1 then do IIO_CHAN_INFO_RAW not the
> averaged version.

That's what I intended to do. Now I see, that I forgot to expose
IIO_CHAN_INFO_RAW. Sorry for the confusion.

> >>>+static const struct iio_chan_spec twl4030_madc_iio_channels[] =3D {
> >>>+	ADC_CHANNEL(0, IIO_VOLTAGE, "ADCIN0", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(1, IIO_TEMP, "ADCIN1", BIT(IIO_CHAN_INFO_PROCESSED) |
> >>>+					   BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
> >>>+	ADC_CHANNEL(2, IIO_VOLTAGE, "ADCIN2", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(3, IIO_VOLTAGE, "ADCIN3", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(4, IIO_VOLTAGE, "ADCIN4", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(5, IIO_VOLTAGE, "ADCIN5", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(6, IIO_VOLTAGE, "ADCIN6", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(7, IIO_VOLTAGE, "ADCIN7", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(8, IIO_VOLTAGE, "ADCIN8", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(9, IIO_VOLTAGE, "ADCIN9", BIT(IIO_CHAN_INFO_AVERAGE_RAW)=
),
> >>>+	ADC_CHANNEL(10, IIO_CURRENT, "ADCIN10", BIT(IIO_CHAN_INFO_PROCESSED)=
 |
> >>>+						BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
> >>>+	ADC_CHANNEL(11, IIO_VOLTAGE, "ADCIN11", BIT(IIO_CHAN_INFO_AVERAGE_RA=
W)),
> >>>+	ADC_CHANNEL(12, IIO_VOLTAGE, "ADCIN12", BIT(IIO_CHAN_INFO_AVERAGE_RA=
W)),
> >>>+	ADC_CHANNEL(13, IIO_VOLTAGE, "ADCIN13", BIT(IIO_CHAN_INFO_AVERAGE_RA=
W)),
> >>>+	ADC_CHANNEL(14, IIO_VOLTAGE, "ADCIN14", BIT(IIO_CHAN_INFO_AVERAGE_RA=
W)),
> >>>+	ADC_CHANNEL(15, IIO_VOLTAGE, "ADCIN15", BIT(IIO_CHAN_INFO_AVERAGE_RA=
W)),
> >>>+};
> >>>+
> >>Why the artificial limitation of one of these devices?  I guess this is=
 to
> >>allow the exported function to work without needing to be associated wi=
th
> >>any particular device...  Hmm.
> >
> >Artificial limitation? The madc is a ADC, which has some special
> >functions defined for some pins in the datasheet:
> >
> >ADC0 =3D Battery Voltage
> >ADC1 =3D Battery Temperature
> >ADC10 =3D Battery Current
> >
> >Nokia misused some of those pins on the Nokia N900, though. For
> >example they have their own conversion tables for the temperature,
> >which is not compatible with the generic one for the madc module.
>=20
> *laughs*.  If someone documents a pin as having a particular purpose
> but it isn't wired inside a package. Someone will always think they know
> better.  Basic principal is to never limit ourselves to one instance of
> a chip because the chances of someone deciding to do something interesting
> with multiple chips is way to high.

;)

> >
> >I planned to convert the rx51-battery driver to simply read the raw
> >values. All other users can use the processed information.
> Makes sense.

ok :)

> [...]
> >>>+	if (count_req)
> >>>+		dev_err(madc->dev, "%d channel conversion failed\n", count_req);
> >>>+
> >>>+	return count;
> >>This is already apparant from the errors emmited earlier. I'd drop this
> >>and the count_req counter in general.
> >>Personally I'd error out in those cases anyway rather than carrying on
> >>with the rest of the channels. If it's worth of a dev_err it's worthy
> >>of getting out as fast as possible rather than trying to muddle on.
> >
> >I also think this should be postponed until the old API is removed.
> I'd prefer to see standalone cleanups and fixes integrated first as I sus=
pect
> it may be a little while before we manage to fully drop the old API.

ok. I have included this change in the fixup patch. This slightly
changes the old API (callback may be called with negative error
values), but the callback feature doesn't seem to be used by any
mainline user.

> [...]
> >>Can this and the previous loop not be combined thus simplifying some te=
sts?
> >
> >It probably can be, but I think this can wait until the old API is
> >removed.
> Hmm. As I state below, if this is moving over to IIO (which is sensible) =
it
> becomes my problem so I reserve the right to be fussy about less than opt=
imal
> code.  If it was coming in clean as a new driver I'd push back hard on a =
lot
> of this stuff before merging it.  I have plenty of slightly uggly drivers
> in staging to look after as it is!

I would feel more comfortable leaving the second loop as is for now.
It's a speed optimization, which acknowledges all IRQs as fast as
possible (=3D> before triggering further conversion of the raw data).

> [...]
> >>>+static int twl4030_madc_start_conversion(struct twl4030_madc_data *ma=
dc,
> >>>+					 int conv_method)
> >>>+{
> >>>+	const struct twl4030_madc_conversion_method *method;
> >>>+	int ret =3D 0;
> >>>+	method =3D &twl4030_conversion_methods[conv_method];
> >>>+	switch (conv_method) {
> >>Can we get here via any paths where these aren't the methods set?
> >
> >conv_method is set from outside of the driver, so it's probably
> >safer to check. This can be simplified once the old API is removed.
> Then we should be returning an error if it's not one of these.

right and reading the code more carefully it should be tested before
using it for array access.

> >I assume, that the driver will get a huge cleanup once all consumers
> >of the old API are converted. Maybe a deprecation flag should be
> >added together with this patchset?
> Probably not worth bothering for an inkernel interface that seems to have
> relatively few users.  How many out of tree users will be moving to
> new kernels and using this device?

At least no new twl4030-madc consumer has been posted to
linux-kernel or linux-omap in the last months. So I will
ignore this.

> [...]
> >>Personally I'd rank the driver as rather to vebose on read error messag=
es
> >>given they are pretty unusual.  Ah well I guess each to their own.
> >
> >All of this is not written by me.
> Sure.  Doesn't stop me moaning :)  At the end of the day you are proposin=
g moving
> this driver into a place where it becomes at least partly my problem.  As=
 such
> I'm keen on any tidying / cleaning occuring ASAP.

Fair enough.

-- Sebastian

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTCm/EAAoJENju1/PIO/qafkMP/iqIYx2kDY4gi2wMZ32oO7nz
64IYo8w8yAxLyt1HnelnzmLlbbhkDTzcMPU/PEq9fFTHOIQNHZfWRWTBKAIJOLuk
d7AzuQEJ/evzcLieERDaAUZBhXdm4KmH2+fF6Vze/OUr/NJs3w7ux2zoLGd0Aunp
Umkz81SGV76UTItFTFHJpcUR7qFvYLaqtuxfNKpZZJkcKj47WxNMyvq4jDgFFFb5
+YiAdIYSKlSlkeWupattRf3HVjlAxOAvAb4qLebe/KjD4JtiWd3nxZ3740uujp+c
wSN6EuRyOXXvMssqzXHMd3XWxUZiuge0s1Vkfo3QuJGGgpwudQQzDyIRNvdib+zi
ph0lCigDTRr2i3ibSbwi91M3xfcDdgveJkEzjAm3KCqbZ03EyU+7EeGkOim4k7dY
K6Jlwkcc2K/akNMA/sx7P/vXhGm5vrH5BaHuQ1xVvyrELciTckMqCMxPtBlXp9Zt
9z9b+CA/TsrYS4oSsikpiycqrAwYVUPuTilaJM3nhXeN78PUFlraudKB0XYxnc4I
n+ESB7zPz/DRnWxG6x4hEXappnoWo8y6fZk352KA0VHTdKukZfYmzoUeqkNcA7dc
khmp7MBI1E56NB+ISsb/k91OanUF2G7KWREUH/m4POgZ7a+MFXZZbXX+n3SlgNa6
9f1UU8vnUeVf/GYHIVzB
=oxKL
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
