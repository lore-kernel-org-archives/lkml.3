Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaKLIy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:54:57 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:42863 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKLIyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:54:54 -0500
Message-ID: <1415782511.4820.2.camel@mm-sol.com>
Subject: Re: [PATCH v4 2/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Wed, 12 Nov 2014 10:55:11 +0200
In-Reply-To: <54629026.3080002@gmx.de>
References: <1415028270-25860-1-git-send-email-iivanov@mm-sol.com>
		 <1415028270-25860-3-git-send-email-iivanov@mm-sol.com>
		 <54612A0D.7020308@gmx.de> <1415694109.22935.13.camel@mm-sol.com>
	 <54629026.3080002@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-11-11 at 23:39 +0100, Hartmut Knaack wrote:
> Ivan T. Ivanov schrieb am 11.11.2014 09:21:
> > Hi Hartmut,
> > 
> > On Mon, 2014-11-10 at 22:11 +0100, Hartmut Knaack wrote:
> > > Ivan T. Ivanov schrieb am 03.11.2014 16:24:
> > > > From: Stanimir Varbanov <svarbanov@mm-sol.com>
> > > > 
> > > > The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> > > > 15 bits resolution and register space inside PMIC accessible across
> > > > SPMI bus.
> > > > 
> > > > The vadc driver registers itself through IIO interface.
> > > Reviewing again, I got the feeling that due to the complexity of adc reads (writing to 
> > > register
> > > to start conversion, waiting a decent time for the conversion to complete, reading the 
> > > result),
> > > it would be beneficial to use a mutex in vadc_read_raw or its depending functions.
> > 
> > Hm, yes, but there is such a nice info_exist_lock :-) in core functions,
> > which in practice serve the same purpose.
> I seem to miss that. Please point me in the right direction.

I am referring to info_exist_lock mutex part of struct iio_dev. 
It protects all operations inkern.c, no?

> > > 
> > > > +
> > > > +       ret = of_property_read_u32(node, "reg", &res);
> > > For u16, there would be of_property_read_u16().
> > > > +       if (ret < 0)
> > > > +       return -ENODEV;
> > > Just return ret here?
> > 
> > I am usually trying to follow these recommendations[1]. In practice driver
> > core cares only for EPROBE_DEFER, ENODEV and ENXIO, while of_property_read_u32()
> > can return ENODATA and EOVERFLOW, which did't not make sense for the core.
> Please point me in the right direction on this one, too. It is pretty common to pass error codes 
> up, as it is also mentioned in [1].

Yes, I know that is common to just pass error codes up, but in this case it did't 
make too much sense, I think. Also take a look at realy_probe() and line 343.

> Yet, this thread in [1] seems more like a draft to me, as Greg K-H wrote in the end: "Fair 
> enough, care to respin this and send it out to me for review?"



Yes, but it make sense to me.

Regards,
Ivan
