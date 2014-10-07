Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaJGL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:57:25 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:40353 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaJGL5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:57:23 -0400
Message-ID: <1412683049.1027.60.camel@iivanov-dev>
Subject: Re: [PATCH v3 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, lars <lars@metafoo.de>,
        sachin.kamat@linaro.org, srinivas.pandruvada@linux.intel.com,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Tue, 07 Oct 2014 14:57:29 +0300
In-Reply-To: <542FDF41.2040106@kernel.org>
References: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com>
		 <1411563415-11933-2-git-send-email-svarbanov@mm-sol.com>
		 <542D1B11.8070600@mm-sol.com> <1412251686.1027.15.camel@iivanov-dev>
	 <542FDF41.2040106@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-04 at 12:51 +0100, Jonathan Cameron wrote:
> On 02/10/14 13:08, Ivan T. Ivanov wrote:
> > +iio maintainers
> > 
> > On Thu, 2014-10-02 at 12:29 +0300, Ivan T. Ivanov wrote:
> >> Hi Stan,
> >>
> >> On 09/24/2014 03:56 PM, Stanimir Varbanov wrote:
> >>
> >> <snip>
> >>
> >>> +static int vadc_get_dt_data(struct vadc_priv *vadc, struct device_node *node)
> >>> +{
> >>> +	struct iio_chan_spec *iio_chan = vadc->iio_chans;
> >>> +	const struct vadc_channels *vadc_chan;
> >>> +	struct vadc_channel_prop prop;
> >>> +	struct device_node *child;
> >>> +	int ret, index = 0;
> >>> +
> >>> +	for_each_available_child_of_node(node, child) {
> >>> +		ret = vadc_get_dt_channel_data(vadc->dev, &prop, child);
> >>> +		if (ret)
> >>> +			return ret;
> >>> +
> >>> +		vadc->chan_props[index] = prop;
> >>> +
> >>> +		vadc_chan = &vadc_chans[prop.channel];
> >>> +
> >>> +		iio_chan->channel = prop.channel;
> >>> +		iio_chan->datasheet_name = vadc_chan->datasheet_name;
> >>> +		iio_chan->info_mask_separate = vadc_chan->info_mask;
> >>> +		iio_chan->type = vadc_chan->type;
> >>> +		iio_chan->indexed = 1;
> >>> +		iio_chan->scan_type.sign = 's';
> >>> +		iio_chan->scan_type.realbits = 15;
> >>> +		iio_chan->scan_type.storagebits = 16;
> >>> +		iio_chan->address = index++;
> >>> +
> >>> +		iio_chan++;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>
> >> <snip>
> >>
> >>> +static int vadc_probe(struct platform_device *pdev)
> >>> +{
> >>
> >> <snip>
> >>
> >>> +
> >>> +	indio_dev->dev.parent = dev;
> >>> +	indio_dev->dev.of_node = node;
> >>> +	indio_dev->name = pdev->name;
> >>> +	indio_dev->modes = INDIO_DIRECT_MODE;
> >>> +	indio_dev->info = &vadc_info;
> >>> +	indio_dev->channels = vadc->iio_chans;
> >>> +	indio_dev->num_channels = vadc->nchannels;
> >>
> >> This will not work as we thought. Registration will be fine and entries
> >> in sysfs are created as expected, but this is breaking numbering scheme
> >> for client drivers. For us the problem is that iio framework expect channels
> >> numbering to be linear and channel number should not be greater than
> >> channel count. For example even if die temperature channel is always 8, if
> >> I describe only 5 channels in DTS files (4 for reference points measurement)
> >> and 1 for die temperature, clients could not get OF reference to 
> >> temperature
> >> channel using io-channels = <&pm8941_vadc 8>;
> >>
> >> Jonathan, please, could you advise us.
> I'd like to let the solution you proposed sit on the list a little longer.
> It seems fairly sensible, but lets see what others suggest.

Sure. 

Thank you.
Ivan


