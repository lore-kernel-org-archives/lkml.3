Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3GWIqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:46:14 -0400
Received: from smtp-out-088.synserver.de ([212.40.185.88]:1137 "EHLO
	smtp-out-088.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3GWIqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:46:06 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15441
Message-ID: <51EE4300.7070802@metafoo.de>
Date: Tue, 23 Jul 2013 10:46:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        fabio.estevam@freescale.com, marex@denx.de
Subject: Re: [PATCH v3 4/5] iio: mxs-lradc: add scale_available file to channels
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-5-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374501843-19651-5-git-send-email-hector.palacios@digi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 04:04 PM, Hector Palacios wrote:
[...]
>  
> +static ssize_t mxs_lradc_show_scale_available_ch(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf,
> +		int ch)
> +{
> +	struct iio_dev *iio = dev_to_iio_dev(dev);
> +	struct mxs_lradc *lradc = iio_priv(iio);
> +	int i, len = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(lradc->scale_avail[ch]); i++)
> +		len += sprintf(buf + len, "%d.%09u ",
> +			       lradc->scale_avail[ch][i].integer,
> +			       lradc->scale_avail[ch][i].nano);
> +
> +	len += sprintf(buf + len, "\n");
> +
> +	return len;
> +}
> +
> +static ssize_t mxs_lradc_show_scale_available(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct iio_dev_attr *iio_attr = to_iio_dev_attr(attr);
> +
> +	return mxs_lradc_show_scale_available_ch(dev, attr, buf,
> +						 iio_attr->address);
> +}
> +
> +#define SHOW_SCALE_AVAILABLE_ATTR(ch)					\
> +static IIO_DEVICE_ATTR(in_voltage##ch##_scale_available, S_IRUGO,	\
> +		       mxs_lradc_show_scale_available, NULL, ch)
> +
> +SHOW_SCALE_AVAILABLE_ATTR(0);
> +SHOW_SCALE_AVAILABLE_ATTR(1);
> +SHOW_SCALE_AVAILABLE_ATTR(2);
> +SHOW_SCALE_AVAILABLE_ATTR(3);
> +SHOW_SCALE_AVAILABLE_ATTR(4);
> +SHOW_SCALE_AVAILABLE_ATTR(5);
> +SHOW_SCALE_AVAILABLE_ATTR(6);
> +SHOW_SCALE_AVAILABLE_ATTR(7);
> +SHOW_SCALE_AVAILABLE_ATTR(8);
> +SHOW_SCALE_AVAILABLE_ATTR(9);
> +SHOW_SCALE_AVAILABLE_ATTR(10);
> +SHOW_SCALE_AVAILABLE_ATTR(11);
> +SHOW_SCALE_AVAILABLE_ATTR(12);
> +SHOW_SCALE_AVAILABLE_ATTR(13);
> +SHOW_SCALE_AVAILABLE_ATTR(14);
> +SHOW_SCALE_AVAILABLE_ATTR(15);
> +
> +static struct attribute *mxs_lradc_attributes[] = {
> +	&iio_dev_attr_in_voltage0_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage1_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage2_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage3_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage4_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage5_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage6_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage7_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage8_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage9_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage10_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage11_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage12_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage13_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage14_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage15_scale_available.dev_attr.attr,
> +	NULL
> +};

This should really be using the iio_chan_spec_ext_info infrastructure. Bonus
points for factoring out the common code used to calculate and display the
scales.

- Lars
